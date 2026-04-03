import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/announcement_model.dart';

class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  Future<List<AnnouncementModel>> getAnnouncements(String schoolId) async {
    final snapshot = await _firestore
        .collection('announcements')
        .where('schoolId', isEqualTo: schoolId) // Filter by school
        .get();
    return snapshot.docs.map((doc) => AnnouncementModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    await _firestore.collection('announcements').doc(announcement.id).update(announcement.toMap());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection('announcements').doc(id).delete();
  }
}

class AnnouncementProvider with ChangeNotifier {
  final AnnouncementRepository _repository = AnnouncementRepository();
  bool _isLoading = false;
  List<AnnouncementModel> _announcements = [];

  bool get isLoading => _isLoading;
  List<AnnouncementModel> get announcements => _announcements;

  Future<void> fetchAnnouncements(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final list = await _repository.getAnnouncements(schoolId);
      // Sort manually to avoid index requirement
      list.sort((a, b) => b.date.compareTo(a.date));
      _announcements = list;
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addAnnouncement(announcement);
    } catch (e) {
      debugPrint('Error adding announcement: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateAnnouncement(announcement);
      await fetchAnnouncements(announcement.schoolId);
    } catch (e) {
      debugPrint('Error updating announcement: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id, String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteAnnouncement(id);
      await fetchAnnouncements(schoolId);
    } catch (e) {
      debugPrint('Error deleting announcement: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
