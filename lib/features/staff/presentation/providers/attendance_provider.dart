import 'package:flutter/material.dart';
import 'package:management/features/staff/data/attendance_repository.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();
  bool _isLoading = false;
  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  List<AttendanceModel> _history = [];
  AttendanceModel? _existingRecord;

  bool get isLoading => _isLoading;
  List<ClassModel> get classes => _classes;
  List<StudentModel> get students => _students;
  List<AttendanceModel> get history => _history;
  AttendanceModel? get existingRecord => _existingRecord;

  void clearExistingRecord() {
    _existingRecord = null;
    notifyListeners();
  }

  Future<void> fetchClasses(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _classes = await _repository.getClasses(schoolId);
      
      // Auto-seed if empty to ensure something works out of the box
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

  Future<void> fetchTodayAttendance(String classId, String date, String sessionType) async {
    _isLoading = true;
    notifyListeners();
    try {
      _existingRecord = await _repository.getAttendanceRecord(classId, date, sessionType);
    } catch (e) {
      debugPrint('Error fetching record: $e');
      _existingRecord = null;
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
    } catch (e) {
      debugPrint('Error seeding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
