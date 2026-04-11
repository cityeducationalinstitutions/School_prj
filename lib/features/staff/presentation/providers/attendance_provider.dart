import 'package:flutter/material.dart';
import 'package:management/features/staff/data/attendance_repository.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();
  bool _isLoading = false;
  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  List<AttendanceRecord> _history = [];
  List<AttendanceRecord> _currentSessionRecords = [];

  bool get isLoading => _isLoading;
  List<ClassModel> get classes => _classes;
  List<StudentModel> get students => _students;
  List<AttendanceRecord> get history => _history;
  List<AttendanceRecord> get currentSessionRecords => _currentSessionRecords;

  void clearCurrentSessionRecords() {
    _currentSessionRecords = [];
    notifyListeners();
  }

  Future<void> fetchClasses(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _classes = await _repository.getClasses(schoolId);
      
      if (_classes.isEmpty) {
        await seedInitialData();
        _classes = await _repository.getClasses(schoolId);
      }
    } catch (e) {
      debugPrint('Error fetching classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStudents(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _students = await _repository.getStudentsByClass(classId);
    } catch (e) {
      debugPrint('Error fetching students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodayAttendance(String classId, DateTime date, String sessionType) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentSessionRecords = await _repository.getAttendanceRecord(classId, date, sessionType);
    } catch (e) {
      debugPrint('Error fetching records: $e');
      _currentSessionRecords = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAttendance(List<AttendanceRecord> records) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveAttendance(records);
    } catch (e) {
      debugPrint('Error saving attendance: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _history = await _repository.getAttendanceHistory(classId);
    } catch (e) {
      debugPrint('Error fetching history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> seedInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.seedData();
    } catch (e) {
      debugPrint('Error seeding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
