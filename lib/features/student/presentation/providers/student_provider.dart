import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/features/student/data/repositories/student_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StudentProvider with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  final String studentId;
  final String? schoolId;
  final String? _classId;
  final String? _grade;
  final String? _section;

  String? get classId => _classId;
  String? get grade => _grade;
  String? get section => _section;

  StudentProvider({
    required this.studentId, 
    this.schoolId,
    required String? classId,
    required String? grade,
    required String? section,
  }) : _classId = classId, _grade = grade, _section = section {
    debugPrint('StudentProvider Initialized for: $studentId (School: $schoolId, Grade: $_grade, Section: $_section)');
    _loadReadStatus(); // Load persistent notification states
    if (_grade != null && _section != null) {
      fetchDashboardData();
    }
 else {
      debugPrint('WARNING: Student Grade/Section is missing. Dashboard data will NOT be fetched.');
    }
  }

  // Stream Subscriptions
  StreamSubscription? _attendanceSub;
  StreamSubscription? _announcementSub;
  StreamSubscription? _doubtsSub;

  bool _isDisposed = false;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void _cancelAllSubscriptions() {
    _attendanceSub?.cancel();
    _announcementSub?.cancel();
    _doubtsSub?.cancel();
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

  Set<String> _readIds = {}; // Persistent store for read announcement IDs


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
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _loadReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('read_announcements_$studentId');
      if (savedIds != null) {
        _readIds = savedIds.toSet();
        _syncAnnouncementsToNotifications();
      }
    } catch (e) {
      debugPrint('Error loading read status: $e');
    }
  }

  Future<void> _saveReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('read_announcements_$studentId', _readIds.toList());
    } catch (e) {
      debugPrint('Error saving read status: $e');
    }
  }

  void _syncAnnouncementsToNotifications() {
    if (_isDisposed) return;
    
    // Sync to Notifications list for the Notification Center UI
    final announcementNotifs = _announcements.map((a) => AppNotification(
      id: a.id,
      title: a.title,
      message: a.message,
      type: 'announcement',
      createdAt: a.createdAt,
      isRead: _readIds.contains(a.id), // Persistent check
    )).toList();

    // Preserve non-announcement notifications (Exams, Attendance, etc.)
    final otherNotifs = _notifications.where((n) => n.type != 'announcement').toList();
    
    _notifications = [...announcementNotifs, ...otherNotifs];
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    notifyListeners();
  }


  void _initAttendanceStream() {
    _attendanceSub?.cancel();
    debugPrint('Starting Attendance Stream for: $studentId');
    _attendanceSub = _repository.getAttendanceStream(studentId).listen(
      (newAttendance) {
        debugPrint('Attendance Stream received: ${newAttendance.length} records');
        _monthlyAttendance = newAttendance;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('CRITICAL: Attendance Stream Error: $error');
      },
    );
  }

  Future<void> fetchDashboardData() async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    
    // Start reactive streams first so they aren't blocked by subsequent awaited failures
    _initAnnouncementsStream();
    _initDoubtsStream();
    _initAttendanceStream();

    try {
      // Fetch historical data (these might fail if indexes are missing)
      try {
        _diaryEntries = await _repository.getDiaryEntries(_grade!, _section!);
        // Local sorting to avoid index requirements
        _diaryEntries.sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        debugPrint('Diary fetch failed (Check Indexes): $e');
      }

      try {
        _marks = await _repository.getMarks(studentId);
      } catch (e) {
        debugPrint('Marks fetch failed: $e');
      }

      try {
        _exams = await _repository.getExamSchedule(_grade!, _section!);
      } catch (e) {
        debugPrint('Exams fetch failed: $e');
      }

      try {
        _periods = await _repository.getSchedules(_grade!, _section!);
      } catch (e) {
        debugPrint('Schedules fetch failed: $e');
      }

      try {
        _materials = await _repository.getMaterials(_grade!, _section!);
      } catch (e) {
        debugPrint('Materials fetch failed: $e');
      }
      
    } catch (e) {
      debugPrint('Error in dashboard data processing: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _initAnnouncementsStream() {
    if (_grade == null || _section == null) return;
    _announcementSub?.cancel();
    _announcementSub = _repository.getAnnouncementsStream(
      _grade!, 
      _section!, 
      schoolId: schoolId
    ).listen(
      (newAnnouncements) {
        debugPrint('[ANNOUNCEMENT SYNC] Received ${newAnnouncements.length} total notices from Firestore');
        _announcements = newAnnouncements;
        _syncAnnouncementsToNotifications();
        debugPrint('[ANNOUNCEMENT SYNC] Successfully synced ${_notifications.length} notifications to UI');
      },
      onError: (error) {
        debugPrint('Announcement Stream Error: $error');
      },
    );
  }

  void _initDoubtsStream() {
    _doubtsSub?.cancel();
    _doubtsSub = _repository.streamMyDoubts(studentId).listen(
      (newDoubts) {
        _doubts = newDoubts;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Doubts Stream Error: $error');
      },
    );
  }

  Future<void> fetchDiary() async {
    if (_grade == null || _section == null) return;
    _setLoading(true);
    try {
      _diaryEntries = await _repository.getDiaryEntries(_grade!, _section!);
      // Local sorting
      _diaryEntries.sort((a, b) => b.date.compareTo(a.date));
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
       // Local sorting
       _diaryEntries.sort((a, b) => b.date.compareTo(a.date));
       notifyListeners();
    } catch (e) {
      debugPrint('Error fetching diary for date: $e');
    } finally {
      _setLoading(false);
    }
  }

  // No longer needed as stream provides all records
  Future<void> fetchAttendance(int month, int year) async {
    // UI now filters the stream-provided _monthlyAttendance
    notifyListeners();
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
    _setLoading(true);
    try {
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
        
        // Persist to local storage
        if (_notifications[index].type == 'announcement') {
          _readIds.add(id);
          await _saveReadStatus();
        }
        
        notifyListeners();
      }
    } finally {
      _setLoading(false);
    }
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

  @override
  void dispose() {
    _isDisposed = true;
    _cancelAllSubscriptions();
    super.dispose();
  }
}
