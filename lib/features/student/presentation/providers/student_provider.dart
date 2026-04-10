import 'dart:io';
import 'package:flutter/material.dart';
import 'package:management/features/student/data/models/student_models.dart';
import 'package:management/features/student/data/repositories/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  final String studentId;
  String? _classId;
  String? get classId => _classId;

  StudentProvider({required this.studentId}) {
    fetchDashboardData();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<StudentDiaryEntry> _todayDiary = [];
  List<StudentDiaryEntry> get todayDiary => _todayDiary;

  List<StudentAssignment> _upcomingAssignments = [];
  List<StudentAssignment> get upcomingAssignments => _upcomingAssignments;

  Future<void> fetchUpcomingAssignments() async {
    _setLoading(true);
    try {
      // MOCK DATA for Assignments
      await Future.delayed(const Duration(milliseconds: 500));
      _upcomingAssignments = [
        StudentAssignment(
          id: '1',
          subject: 'Mathematics',
          title: 'Calculus Problem Set 4',
          description: 'Solve problems 1-15 from Chapter 4. focus on integration by parts.',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          status: 'pending',
        ),
        StudentAssignment(
          id: '2',
          subject: 'Physics',
          title: 'Lab Report: Electromagnetism',
          description: 'Submit the final lab report including all data tables and graphs.',
          dueDate: DateTime.now().add(const Duration(days: 4)),
          status: 'pending',
        ),
        StudentAssignment(
          id: '3',
          subject: 'English',
          title: 'Essay: Modern Literature',
          description: 'Write a 1500-word essay on the impact of modernism in 20th-century poetry.',
          dueDate: DateTime.now().add(const Duration(days: 7)),
          status: 'completed',
        ),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching assignments: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDiaryForDate(DateTime date) async {
    _setLoading(true);
    try {
      await _ensureClassId();
      _todayDiary = await _repository.getDiaryEntries(_classId!, date);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching diary for date: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<StudentAttendanceRecord> _monthlyAttendance = [];
  List<StudentAttendanceRecord> get monthlyAttendance => _monthlyAttendance;

  List<Map<String, dynamic>> _announcements = [];
  List<Map<String, dynamic>> get announcements => _announcements;

  // Gradebook / Exams
  List<StudentGrade> _grades = [];
  List<StudentGrade> get grades => _grades;

  List<ExamSchedule> _exams = [];
  List<ExamSchedule> get exams => _exams;

  Quiz? _activeQuiz;
  Quiz? get activeQuiz => _activeQuiz;

  // Materials / Quiz
  List<StudentMaterial> _materials = [];
  List<StudentMaterial> get materials => _materials;

  // New Features State
  List<ScheduleEntry> _schedules = [];
  List<ScheduleEntry> get schedules => _schedules;

  List<StudentDoubt> _doubts = [];
  List<StudentDoubt> get doubts => _doubts;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _ensureClassId() async {
    if (_classId != null) return;
    
    try {
      // In a real app, we fetch the student's class from their profile
      // Or from a 'students' collection where docId == studentId
      // For now, if not in user model, we use a default mock class to fix permissions
      _classId = 'mock_1stGrade_A'; 
    } catch (e) {
      _classId = 'mock_1stGrade_A';
    }
  }

  Future<void> fetchDashboardData() async {
    _setLoading(true);
    try {
      await _ensureClassId();
      final now = DateTime.now();
      
      _todayDiary = await _repository.getDiaryEntries(_classId!, now);
      _announcements = await _repository.getAnnouncements();
      _monthlyAttendance = await _repository.getAttendance(studentId, now.month, now.year);
      
      // Fetch new feature basics
      await fetchSchedules();
      await fetchUpcomingAssignments();
      await fetchDoubts();
      _initNotificationsStream();
    } catch (e) {
      debugPrint('Error fetching dashboard: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _initNotificationsStream() {
    _repository.getNotificationsStream(studentId).listen((newNotifications) {
      _notifications = newNotifications;
      notifyListeners();
    });
  }

  Future<void> fetchSchedules() async {
    if (_classId == null) await _ensureClassId();
    try {
      // Mock Data for Senior Developer Elite UI
      await Future.delayed(const Duration(milliseconds: 600));
      _schedules = [
        // Monday
        ScheduleEntry(id: 's1', classId: _classId!, day: 'Monday', subject: 'Mathematics', startTime: '09:00 AM', endTime: '10:00 AM', teacherName: 'Dr. Sarah Wilson', room: 'Room 302'),
        ScheduleEntry(id: 's2', classId: _classId!, day: 'Monday', subject: 'Physics', startTime: '10:15 AM', endTime: '11:15 AM', teacherName: 'Prof. Michael Chen', room: 'Lab Center 1'),
        ScheduleEntry(id: 's3', classId: _classId!, day: 'Monday', subject: 'Computer Science', startTime: '11:30 AM', endTime: '12:30 PM', teacherName: 'Alex Rivera', room: 'Computing Floor 3'),
        ScheduleEntry(id: 's4', classId: _classId!, day: 'Monday', subject: 'English', startTime: '01:30 PM', endTime: '02:30 PM', teacherName: 'Emma Thompson', room: 'Language Lab'),
        
        // Similarly for other days... (Using Monday for Elite Review)
        ScheduleEntry(id: 's5', classId: _classId!, day: 'Tuesday', subject: 'Chemistry', startTime: '09:00 AM', endTime: '10:00 AM', teacherName: 'Dr. Robert Blake', room: 'Chem Lab 2'),
        ScheduleEntry(id: 's6', classId: _classId!, day: 'Wednesday', subject: 'Biology', startTime: '09:00 AM', endTime: '10:00 AM', teacherName: 'Dr. Jane Smith', room: 'Bio Lab 1'),
        
        // Thursday
        ScheduleEntry(id: 's7', classId: _classId!, day: 'Thursday', subject: 'Modern History', startTime: '09:00 AM', endTime: '10:15 AM', teacherName: 'Dr. George Miller', room: 'Main Hall'),
        ScheduleEntry(id: 's8', classId: _classId!, day: 'Thursday', subject: 'Advanced Physics', startTime: '10:30 AM', endTime: '12:00 PM', teacherName: 'Prof. Michael Chen', room: 'Lab Center 1'),
        ScheduleEntry(id: 's11', classId: _classId!, day: 'Thursday', subject: 'Digital Seminar', startTime: '04:00 PM', endTime: '05:00 PM', teacherName: 'Sarah Jenkins', room: 'Online Hub'),
        
        // Friday
        ScheduleEntry(id: 's9', classId: _classId!, day: 'Friday', subject: 'Literature', startTime: '09:00 AM', endTime: '10:00 AM', teacherName: 'Emma Thompson', room: 'Library L3'),
        ScheduleEntry(id: 's10', classId: _classId!, day: 'Friday', subject: 'Art & Design', startTime: '10:15 AM', endTime: '12:00 PM', teacherName: 'Julian Ray', room: 'Art Studio B'),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
    }
  }

  Future<void> fetchDoubts() async {
    try {
      _doubts = await _repository.getMyDoubts(studentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching doubts: $e');
    }
  }

  Future<void> submitDoubt(String subject, String title, String description, {File? attachment}) async {
    _setLoading(true);
    try {
      final doubt = StudentDoubt(
        id: '', // Generated by Firestore
        studentId: studentId,
        subject: subject,
        title: title,
        description: description,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.raiseDoubt(doubt, attachment);
      await fetchDoubts();
    } catch (e) {
      debugPrint('Error submitting doubt: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await _repository.markNotificationAsRead(id);
    } catch (e) {
      debugPrint('Error marking notification read: $e');
    }
  }

  Future<void> fetchMaterials(String subject) async {
    _setLoading(true);
    try {
      _materials = await _repository.getMaterials(subject);
    } catch (e) {
      debugPrint('Error fetching materials: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchGrades() async {
    _setLoading(true);
    try {
      // Mock Data for Senior Developer UI
      await Future.delayed(const Duration(milliseconds: 600));
      _grades = [
        StudentGrade(subject: 'Mathematics', examName: 'Mid-Term 2026', obtainedMarks: 94, totalMarks: 100),
        StudentGrade(subject: 'Physics', examName: 'Mid-Term 2026', obtainedMarks: 88, totalMarks: 100),
        StudentGrade(subject: 'English Literature', examName: 'Mid-Term 2026', obtainedMarks: 91, totalMarks: 100),
        StudentGrade(subject: 'Computer Science', examName: 'Final Project', obtainedMarks: 98, totalMarks: 100),
        StudentGrade(subject: 'History', examName: 'Weekly Quiz', obtainedMarks: 76, totalMarks: 100),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching grades: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchExams() async {
    _setLoading(true);
    try {
      // Mock Data for Senior Developer Elite UI (Updated Exam Types)
      await Future.delayed(const Duration(milliseconds: 600));
      _exams = [
        ExamSchedule(
          id: 'e1',
          subject: 'Mathematics',
          date: DateTime.now().add(const Duration(days: 2)),
          time: const TimeOfDay(hour: 9, minute: 0),
          type: 'Weekly Exam',
          room: 'Classroom 4A',
        ),
        ExamSchedule(
          id: 'e2',
          subject: 'Physics',
          date: DateTime.now().add(const Duration(days: 4)),
          time: const TimeOfDay(hour: 10, minute: 30),
          type: 'Unit Test',
          room: 'Lab Center 1',
        ),
        ExamSchedule(
          id: 'e3',
          subject: 'English Literature',
          date: DateTime.now().add(const Duration(days: 7)),
          time: const TimeOfDay(hour: 9, minute: 0),
          type: 'Quarterly Examination',
          room: 'Examination Hall B',
        ),
        ExamSchedule(
          id: 'e4',
          subject: 'Computer Science',
          date: DateTime.now().add(const Duration(days: 14)),
          time: const TimeOfDay(hour: 14, minute: 0),
          type: 'Half Yearly Examination',
          room: 'Computing Floor 3',
        ),
        ExamSchedule(
          id: 'e5',
          subject: 'Social Studies',
          date: DateTime.now().add(const Duration(days: 30)),
          time: const TimeOfDay(hour: 11, minute: 0),
          type: 'Final Examination',
          room: 'Main Lecture Hall',
        ),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching exams: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<String> startQuizFromMaterial(String materialId) async {
    _setLoading(true);
    try {
      final quizId = await _repository.generateQuiz(materialId, studentId);
      _activeQuiz = await _repository.getQuiz(quizId);
      return quizId;
    } catch (e) {
      debugPrint('Error generating quiz: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitQuiz(int score) async {
    if (_activeQuiz == null) return;
    try {
      await _repository.submitQuizScore(_activeQuiz!.id, score);
    } catch (e) {
      debugPrint('Error submitting quiz: $e');
    }
  }
}
