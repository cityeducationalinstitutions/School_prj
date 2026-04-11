import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:management/models/academic_models.dart';

class AcademicRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // DIARY
  Future<void> saveDiaryEntry(DiaryEntry entry) async {
    await _firestore.collection('diary').doc(entry.id.isEmpty ? null : entry.id).set(entry.toMap());
  }

  // MATERIALS
  Future<void> uploadMaterial(AcademicMaterial material, File file) async {
    // 1. Upload to Storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${material.title.replaceAll(' ', '_')}.pdf';
    final ref = _storage.ref().child('materials').child(material.classId).child(fileName);
    
    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // 2. Save Metadata to Firestore
    final updatedMaterial = AcademicMaterial(
      id: material.id,
      classId: material.classId,
      grade: material.grade,
      section: material.section,
      subject: material.subject,
      title: material.title,
      fileUrl: downloadUrl,
      createdAt: material.createdAt,
    );

    await _firestore.collection('materials').add(updatedMaterial.toMap());
  }

  // ANNOUNCEMENTS
  Future<void> createAnnouncement(Announcement announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  // MARKS
  Future<void> saveMultipleMarks(List<StudentMark> marks) async {
    final batch = _firestore.batch();
    for (var mark in marks) {
      final markRef = _firestore.collection('marks').doc();
      batch.set(markRef, mark.toMap());
    }
    await batch.commit();
  }

  // SCHEDULES
  Future<void> updateSchedule(ClassPeriod schedule) async {
    await _firestore.collection('schedules').doc(schedule.id.isEmpty ? null : schedule.id).set(schedule.toMap());
  }

  // EXAMS
  Future<void> saveExam(AcademicExam exam) async {
    await _firestore.collection('exams').doc(exam.id.isEmpty ? null : exam.id).set(exam.toMap());
  }

  // FETCHING (Staff side often needs class-wide data)
  Future<List<DiaryEntry>> getDiaryByClass(String classId) async {
    final snapshot = await _firestore
        .collection('diary')
        .where('classId', isEqualTo: classId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<AcademicMaterial>> getMaterialsByClass(String classId) async {
    final snapshot = await _firestore
        .collection('materials')
        .where('classId', isEqualTo: classId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => AcademicMaterial.fromMap(doc.data(), doc.id)).toList();
  }
}
