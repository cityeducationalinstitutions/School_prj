import 'package:flutter/material.dart';
import 'package:management/features/staff/data/attendance_repository.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();
  bool _isLoading = false;
  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  List<AttendanceModel> _history = [];

  bool get isLoading => _isLoading;
  List<ClassModel> get classes => _classes;
  List<StudentModel> get students => _students;
  List<AttendanceModel> get history => _history;

  Future<void> fetchClasses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _classes = await _repository.getClasses();
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

  Future<void> saveAttendance(AttendanceModel attendance) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveAttendance(attendance);
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
      await fetchClasses(); // Refresh
    } catch (e) {
      debugPrint('Error seeding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
