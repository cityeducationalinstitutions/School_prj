import 'dart:io';
import 'package:flutter/material.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/features/student/data/repositories/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  final String studentId;
  final String? _classId;
  final String? _grade;
  final String? _section;

  String? get classId => _classId;
  String? get grade => _grade;
  String? get section => _section;

  StudentProvider({
    required this.studentId, 
    required String? classId,
    required String? grade,
    required String? section,
  }) : _classId = classId, _grade = grade, _section = section {
    if (_grade != null && _section != null) {
      fetchDashboardData();
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DiaryEntry> _diaryEntries = [];
  List<DiaryEntry> get diaryEntries => _diaryEntries;

  List<AttendanceRecord> _monthlyAttendance = [];
  List<AttendanceRecord> get monthlyAttendance => _monthlyAttendance;

  List<Announcement> _announcements = [];
  List<Announcement> get announcements => _announcements;

  List<StudentMark> _marks = [];
  List<StudentMark> get marks => _marks;

  List<AcademicExam> _exams = [];
  List<AcademicExam> get exams => _exams;

  List<AcademicMaterial> _materials = [];
  List<AcademicMaterial> get materials => _materials;

  List<ClassPeriod> _periods = [];
  List<ClassPeriod> get periods => _periods;

  List<AcademicDoubt> _doubts = [];
  List<AcademicDoubt> get doubts => _doubts;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  // Notification Getter
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  // Quiz Mock Logic
  dynamic _activeQuiz; // Placeholder for Quiz model
  dynamic get activeQuiz => _activeQuiz;

  // Diary Getters
  List<DiaryEntry> get todayDiary {
    final now = DateTime.now();
    return _diaryEntries.where((e) => 
      e.date.year == now.year && 
      e.date.month == now.month && 
      e.date.day == now.day
    ).toList();
  }

  List<DiaryEntry> get upcomingAssignments {
    final now = DateTime.now();
    return _diaryEntries.where((e) => 
      e.homework.isNotEmpty && 
      (e.date.isAfter(now) || 
       (e.date.year == now.year && e.date.month == now.month && e.date.day == now.day))
    ).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _initAttendanceStream() {
    _repository.getAttendanceStream(studentId).listen((newAttendance) {
      _monthlyAttendance = newAttendance;
      notifyListeners();
    });
  }

  Future<void> fetchDashboardData() async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    try {
      final now = DateTime.now();
      
      _diaryEntries = await _repository.getDiaryEntries(_grade!, _section!);
      _marks = await _repository.getMarks(studentId);
      _exams = await _repository.getExamSchedule(_grade!, _section!);
      _periods = await _repository.getSchedules(_grade!, _section!);
      _materials = await _repository.getMaterials(_grade!, _section!);
      
      _initAnnouncementsStream();
      _initDoubtsStream();
      _initAttendanceStream();
    } catch (e) {
      debugPrint('Error fetching dashboard: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _initAnnouncementsStream() {
    if (_grade == null || _section == null) return;
    _repository.getAnnouncementsStream(_grade!, _section!).listen((newAnnouncements) {
      _announcements = newAnnouncements;
      notifyListeners();
    });
  }

  void _initDoubtsStream() {
    _repository.streamMyDoubts(studentId).listen((newDoubts) {
      _doubts = newDoubts;
      notifyListeners();
    });
  }

  Future<void> fetchDiary() async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    try {
      _diaryEntries = await _repository.getDiaryEntries(_grade!, _section!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching diary: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDiaryForDate(DateTime date) async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    try {
       _diaryEntries = await _repository.getDiaryEntries(_grade!, _section!);
       notifyListeners();
    } catch (e) {
      debugPrint('Error fetching diary for date: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAttendance(int month, int year) async {
    _setLoading(true);
    try {
      _monthlyAttendance = await _repository.getAttendance(studentId, month, year);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMaterials([String? subject]) async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    try {
      _materials = await _repository.getMaterials(_grade!, _section!, subject: subject);
    } catch (e) {
      debugPrint('Error fetching materials: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitDoubt(String subject, String title, String description, {File? attachment}) async {
    if (_classId == null) return;
    _setLoading(true);
    try {
      final doubt = AcademicDoubt(
        id: '',
        studentId: studentId,
        classId: _classId!,
        grade: _grade!,
        section: _section!,
        subject: subject,
        title: title,
        description: description,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _repository.raiseDoubt(doubt, attachment);
    } catch (e) {
      debugPrint('Error submitting doubt: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markNotificationRead(String id) async {
    // Local update for immediate feedback
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        createdAt: _notifications[index].createdAt,
        isRead: true,
      );
      notifyListeners();
    }
    // Remote update would go here via repo
  }

  Future<void> startQuizFromMaterial(String materialId) async {
    // Implementation for AI quiz generation would go here
    _activeQuiz = { 'id': 'mock_quiz_1', 'questions': [] }; // Mock quiz object
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> submitQuiz(int score) async {
    // Implementation for quiz submission
    _activeQuiz = null;
    notifyListeners();
  }
}
