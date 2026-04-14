import 'package:flutter/material.dart';
import 'package:management/features/staff/data/grade_book_repository.dart';
import 'package:management/models/grade_models.dart';

class GradeBookProvider with ChangeNotifier {
  final GradeBookRepository _repository = GradeBookRepository();
  bool _isLoading = false;
  List<MarksModel> _marks = [];
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

  bool get isLoading => _isLoading;
  List<MarksModel> get marks => _marks;

  Future<void> fetchMarksByClassAndSubject(String classId, String subject) async {
    _isLoading = true;
    notifyListeners();
    try {
      _marks = await _repository.getMarksByClassAndSubject(classId, subject);
    } catch (e) {
      debugPrint('Error fetching marks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMarksByClass(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _marks = await _repository.getMarksByClass(classId);
    } catch (e) {
      debugPrint('Error fetching class marks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMark(MarksModel mark) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveMark(mark);
    } catch (e) {
      debugPrint('Error saving mark: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
