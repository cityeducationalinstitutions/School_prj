import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/features/staff/data/academic_repository.dart';

class MaterialProvider with ChangeNotifier {
  final AcademicRepository _repository = AcademicRepository();
  bool _isLoading = false;
  List<AcademicMaterial> _materials = [];

  bool get isLoading => _isLoading;
  List<AcademicMaterial> get materials => _materials;

  Future<void> fetchMaterials(String grade, String section) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('materials')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .get();
      
      _materials = snapshot.docs
          .map((doc) => AcademicMaterial.fromMap(doc.data(), doc.id))
          .toList();
      _materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error fetching materials: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadMaterial({
    required File file,
    required String title,
    required String classId,
    required String grade,
    required String section,
    required String subject,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final material = AcademicMaterial(
        id: '',
        classId: classId,
        grade: grade,
        section: section,
        subject: subject,
        title: title,
        fileUrl: '', // Will be set by repo
        createdAt: DateTime.now(),
      );

      await _repository.uploadMaterial(material, file);
      await fetchMaterials(grade, section);
    } catch (e) {
      debugPrint('Error uploading: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMaterial(String id, String grade, String section) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('materials').doc(id).delete();
      await fetchMaterials(grade, section);
    } catch (e) {
      debugPrint('Error deleting: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMaterialTitle(String id, String newTitle, String grade, String section) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('materials').doc(id).update({'title': newTitle});
      await fetchMaterials(grade, section);
    } catch (e) {
      debugPrint('Error updating title: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
