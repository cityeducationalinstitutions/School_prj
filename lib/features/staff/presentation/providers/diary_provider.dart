import 'package:flutter/material.dart';
import 'package:management/features/staff/data/academic_repository.dart';
import 'package:management/models/academic_models.dart';

class DiaryProvider with ChangeNotifier {
  final AcademicRepository _repository = AcademicRepository();
  bool _isLoading = false;
  List<DiaryEntry> _entries = [];

  bool get isLoading => _isLoading;
  List<DiaryEntry> get entries => _entries;

  Future<void> fetchEntries(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _entries = await _repository.getDiaryByClass(classId);
    } catch (e) {
      debugPrint('Error fetching diary: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(DiaryEntry entry) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveDiaryEntry(entry);
      await fetchEntries(entry.classId);
    } catch (e) {
      debugPrint('Error adding diary: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveDiaryEntry(entry);
      await fetchEntries(entry.classId);
    } catch (e) {
      debugPrint('Error updating diary: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Note: AcademicRepository doesn't have delete yet, adding it logic here for consistency
  Future<void> deleteEntry(String id, String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Direct delete if not in repository yet
      // await _repository.deleteDiaryEntry(id);
      await fetchEntries(classId);
    } catch (e) {
      debugPrint('Error deleting diary: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
