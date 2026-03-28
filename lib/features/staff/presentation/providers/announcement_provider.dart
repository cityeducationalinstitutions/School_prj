import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/announcement_model.dart';

class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final snapshot = await _firestore
        .collection('announcements')
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => AnnouncementModel.fromMap(doc.data(), doc.id)).toList();
  }
}

class AnnouncementProvider with ChangeNotifier {
  final AnnouncementRepository _repository = AnnouncementRepository();
  bool _isLoading = false;
  List<AnnouncementModel> _announcements = [];

  bool get isLoading => _isLoading;
  List<AnnouncementModel> get announcements => _announcements;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();
    try {
      _announcements = await _repository.getAnnouncements();
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
}
