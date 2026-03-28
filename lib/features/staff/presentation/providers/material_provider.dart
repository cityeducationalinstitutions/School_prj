import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:management/models/material_model.dart';

class MaterialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> saveMaterial(MaterialModel material) async {
    await _firestore.collection('materials').add(material.toMap());
  }

  Future<List<MaterialModel>> getMaterialsByClass(String classId) async {
    final snapshot = await _firestore
        .collection('materials')
        .where('classId', isEqualTo: classId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => MaterialModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> deleteMaterial(String id, String fileUrl) async {
    await _firestore.collection('materials').doc(id).delete();
  }
}

class MaterialProvider with ChangeNotifier {
  final MaterialRepository _repository = MaterialRepository();
  bool _isLoading = false;
  List<MaterialModel> _materials = [];

  bool get isLoading => _isLoading;
  List<MaterialModel> get materials => _materials;

  Future<void> fetchMaterials(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _materials = await _repository.getMaterialsByClass(classId);
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
    required String uploadedBy,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fileName = file.path.split('/').last;
      final path = 'materials/$classId/$fileName';
      final fileUrl = await _repository.uploadFile(file, path);

      final material = MaterialModel(
        id: '',
        classId: classId,
        title: title,
        fileUrl: fileUrl,
        fileName: fileName,
        uploadedBy: uploadedBy,
        timestamp: DateTime.now().toIso8601String(),
      );

      await _repository.saveMaterial(material);
      await fetchMaterials(classId);
    } catch (e) {
      debugPrint('Error uploading: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMaterial(String id, String fileUrl, String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteMaterial(id, fileUrl);
      await fetchMaterials(classId);
    } catch (e) {
      debugPrint('Error deleting: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
