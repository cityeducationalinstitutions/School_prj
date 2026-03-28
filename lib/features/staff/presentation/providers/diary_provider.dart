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
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => DiaryModel.fromMap(doc.data(), doc.id)).toList();
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
      _entries = await _repository.getDiaryEntries(classId);
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
}
