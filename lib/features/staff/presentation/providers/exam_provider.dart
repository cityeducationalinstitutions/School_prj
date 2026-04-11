import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/features/staff/data/academic_repository.dart';

class StaffExamProvider with ChangeNotifier {
  final AcademicRepository _repository = AcademicRepository();
  bool _isLoading = false;
  List<AcademicExam> _exams = [];

  bool get isLoading => _isLoading;
  List<AcademicExam> get exams => _exams;

  Future<void> fetchExams(String grade, String section) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('exams')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .get();
      
      _exams = snapshot.docs
          .map((doc) => AcademicExam.fromMap(doc.data(), doc.id))
          .toList();
      _exams.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      debugPrint('Error fetching exams: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createExam(AcademicExam exam) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveExam(exam);
      await fetchExams(exam.grade, exam.section);
    } catch (e) {
      debugPrint('Error creating exam: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteExam(String id, String grade, String section) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('exams').doc(id).delete();
      await fetchExams(grade, section);
    } catch (e) {
      debugPrint('Error deleting exam: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
