import 'package:flutter/material.dart';
import 'package:management/features/staff/data/attendance_repository.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceProvider with ChangeNotifier {
  static bool shouldShowSection(String? schoolId) {
    if (schoolId == null) return true;
    return !['new-vision', 'city-elite'].contains(schoolId.toLowerCase());
  }

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
      final fetchedClasses = await _repository.getClasses(schoolId);
      
      if (fetchedClasses.isEmpty) {
        await seedInitialData();
        _classes = await _repository.getClasses(schoolId);
      } else {
        _classes = fetchedClasses;
      }

      // Smart Sorting Logic
      _sortClasses();
    } catch (e) {
      debugPrint('Error fetching classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _sortClasses() {
    _classes.sort((a, b) {
      // 1. Numerical Grade Sort (extract 1 from "1st Grade", 10 from "10th Grade")
      int getGradeNum(String name) {
        final match = RegExp(r'(\d+)').firstMatch(name);
        return match != null ? int.parse(match.group(1)!) : 99;
      }

      final gradeA = getGradeNum(a.name);
      final gradeB = getGradeNum(b.name);

      if (gradeA != gradeB) {
        return gradeA.compareTo(gradeB);
      }

      // 2. Institutional Section Priority Sort
      int getSectionPriority(String sec) {
        const priorityMap = {
          'A': 1, 'B': 2, 'C': 3,
          'S1': 4, 'S2': 5, 'Talent': 6, 'Regular': 7
        };
        return priorityMap[sec.toUpperCase()] ?? 99;
      }

      return getSectionPriority(a.section).compareTo(getSectionPriority(b.section));
    });
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
      // Local sorting to avoid index requirements
      _history.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      debugPrint('Error fetching history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> get availableGrades {
    final grades = _classes.map((c) => c.name).toSet().toList();
    // Numerical sort
    grades.sort((a, b) {
      final numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });
    return grades;
  }

  List<String> getSectionsForGrade(String gradeName) {
    final rawSections = _classes
        .where((c) => c.name == gradeName)
        .map((c) => c.section.trim())
        .toList();

    // Normalization & Deduplication (Title Case for long names, Upper for codes)
    final normalized = rawSections.map((s) {
      final upper = s.toUpperCase();
      if (['S1', 'S2', 'A', 'B', 'C'].contains(upper)) return upper;
      // Title Case for Talent, Regular
      if (upper == 'TALENT') return 'Talent';
      if (upper == 'REGULAR') return 'Regular';
      return s; // Fallback
    }).toSet().toList();
    
    const priorityMap = {
      'A': 1, 'B': 2, 'C': 3,
      'S1': 4, 'S2': 5, 'Talent': 6, 'Regular': 7
    };
    
    normalized.sort((a, b) => (priorityMap[a] ?? 99).compareTo(priorityMap[b] ?? 99));
    return normalized;
  }

  ClassModel? getClassByGradeAndSection(String grade, String section) {
    try {
      return _classes.firstWhere(
        (c) => c.name == grade && c.section.trim().toLowerCase() == section.trim().toLowerCase()
      );
    } catch (_) {
      return null;
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

  bool _isDisposed = false;
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
