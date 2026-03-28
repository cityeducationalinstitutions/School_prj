import 'package:flutter/material.dart';
import 'package:management/features/staff/data/grade_book_repository.dart';
import 'package:management/models/grade_models.dart';

class GradeBookProvider with ChangeNotifier {
  final GradeBookRepository _repository = GradeBookRepository();
  bool _isLoading = false;
  List<MarksModel> _marks = [];

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
