import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/features/staff/data/academic_repository.dart';

class AnnouncementProvider with ChangeNotifier {
  final AcademicRepository _repository = AcademicRepository();
  bool _isLoading = false;
  List<Announcement> _announcements = [];

  bool get isLoading => _isLoading;
  List<Announcement> get announcements => _announcements;

  Future<void> fetchAnnouncements(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('announcements')
          .get(); 
      
      _announcements = snapshot.docs
          .map((doc) => Announcement.fromMap(doc.data(), doc.id))
          .toList();
      _announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAnnouncement(Announcement announcement) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.createAnnouncement(announcement);
      await fetchAnnouncements('temp_id'); // Refresh
    } catch (e) {
      debugPrint('Error adding announcement: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(announcement.id)
          .set(announcement.toMap());
      await fetchAnnouncements('temp_id');
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
      await FirebaseFirestore.instance.collection('announcements').doc(id).delete();
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
