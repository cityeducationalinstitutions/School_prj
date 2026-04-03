import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/diary_model.dart';

class DiaryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDiaryEntry(DiaryModel entry) async {
    await _firestore.collection('dairy').add(entry.toMap());
  }

  Future<List<DiaryModel>> getDiaryEntries(String classId) async {
    final snapshot = await _firestore
        .collection('dairy')
        .where('classId', isEqualTo: classId)
        .get();
    return snapshot.docs.map((doc) => DiaryModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateDiaryEntry(DiaryModel entry) async {
    await _firestore.collection('dairy').doc(entry.id).update(entry.toMap());
  }

  Future<void> deleteDiaryEntry(String id) async {
    await _firestore.collection('dairy').doc(id).delete();
  }
}

class DiaryProvider with ChangeNotifier {
  final DiaryRepository _repository = DiaryRepository();
  bool _isLoading = false;
  List<DiaryModel> _entries = [];

  bool get isLoading => _isLoading;
  List<DiaryModel> get entries => _entries;

  Future<void> fetchEntries(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final list = await _repository.getDiaryEntries(classId);
      list.sort((a, b) => b.date.compareTo(a.date));
      _entries = list;
    } catch (e) {
      debugPrint('Error fetching diary: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(DiaryModel entry) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addDiaryEntry(entry);
    } catch (e) {
      debugPrint('Error adding diary: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEntry(DiaryModel entry) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateDiaryEntry(entry);
      await fetchEntries(entry.classId);
    } catch (e) {
      debugPrint('Error updating diary: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id, String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteDiaryEntry(id);
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
