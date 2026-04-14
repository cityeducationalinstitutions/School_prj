import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/attendance_models.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // DIARY (Synchronized with Staff 'diary' collection)
  Future<List<DiaryEntry>> getDiaryEntries(String grade, String section) async {
    final normalizedSection = section.toLowerCase();
    
    final snapshot = await _firestore
        .collection('diary')
        .where('grade', isEqualTo: grade)
        .get();
    
    return snapshot.docs
        .map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .where((entry) => entry.section.toLowerCase() == normalizedSection)
        .toList();
  }

  // ATTENDANCE (Personal history, Real-time Stream)
  Stream<List<AttendanceRecord>> getAttendanceStream(String studentId) {
    return _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
          final records = <AttendanceRecord>[];
          for (var doc in snapshot.docs) {
            try {
              records.add(AttendanceRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id));
            } catch (e) {
              print('Warning: Skipping malformed attendance record ${doc.id}: $e');
            }
          }
          return records;
        });
  }

  Future<List<AttendanceRecord>> getAttendance(String studentId, int month, int year) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0); // Last day of the month

    // The stream is typically better for real-time, but for history 
    // we use normalized midnight timestamps.
    final snapshot = await _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    return snapshot.docs
        .map((doc) => AttendanceRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // MATERIALS (Institutional)
  Future<List<AcademicMaterial>> getMaterials(String grade, String section, {String? subject}) async {
    Query query = _firestore.collection('materials')
        .where('grade', isEqualTo: grade)
        .where('section', isEqualTo: section);
    
    if (subject != null && subject != 'All') {
      query = query.where('subject', isEqualTo: subject);
    }

    final snapshot = await query.get();
    
    return snapshot.docs
        .map((doc) => AcademicMaterial.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // MARKS (Personal grades)
  Future<List<StudentMark>> getMarks(String studentId) async {
    final snapshot = await _firestore
        .collection('marks')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs.map((doc) => StudentMark.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // EXAMS (Institutional)
  Future<List<AcademicExam>> getExamSchedule(String grade, String section) async {
    final snapshot = await _firestore
        .collection('exams')
        .where('grade', isEqualTo: grade)
        .where('section', isEqualTo: section)
        .get();

    return snapshot.docs
        .map((doc) => AcademicExam.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // ANNOUNCEMENTS (Institutional, Real-time Stream)
  Stream<List<Announcement>> getAnnouncementsStream(String grade, String section, {String? schoolId}) {
    // Note: Fetching broadly to allow for historical data and global notices
    // that might be missing the schoolId field.
    return _firestore.collection('announcements').snapshots().map((snapshot) {
      final normSection = section.trim().toLowerCase();
      final normGrade = grade.trim().toLowerCase();

      final announcements = snapshot.docs
          .map((doc) => Announcement.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((a) {
            // Institutional Check: Show if school matches OR if notice is untagged (Legacy/Global)
            final isInstitutional = schoolId == null || a.schoolId == null || a.schoolId == schoolId;
            if (!isInstitutional) return false;

            // Audience Check
            final isGlobal = a.grade.trim().toLowerCase() == 'all';
            
            // Smart Matching: Trim and Case-Insensitive
            final aGrade = a.grade.trim().toLowerCase();
            final aSection = a.section.trim().toLowerCase();
            
            final isMatch = aGrade == normGrade && aSection == normSection;
            
            return isGlobal || isMatch;
          })
          .toList();

      // Client-side sort: Latest first
      announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return announcements;
    });
  }

  // SCHEDULES (Institutional)
  Future<List<ClassPeriod>> getSchedules(String grade, String section) async {
    final snapshot = await _firestore
        .collection('schedules')
        .where('grade', isEqualTo: grade)
        .where('section', isEqualTo: section)
        .get();

    return snapshot.docs
        .map((doc) => ClassPeriod.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // DOUBTS (Personal, Real-time Stream for replies)
  Stream<List<AcademicDoubt>> streamMyDoubts(String studentId) {
    // Note: Removed server-side .orderBy('createdAt') to bypass composite index requirement.
    // We sort client-side instead.
    return _firestore
        .collection('doubts')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      final doubts = snapshot.docs
          .map((doc) => AcademicDoubt.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Client-side sort: Latest first
      doubts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return doubts;
    });
  }

  Future<void> raiseDoubt(AcademicDoubt doubt, File? attachment) async {
    String? attachmentUrl;

    if (attachment != null) {
      final ref = _storage
          .ref()
          .child('doubts')
          .child('${DateTime.now().millisecondsSinceEpoch}_${doubt.studentId}.jpg');
      
      await ref.putFile(attachment);
      attachmentUrl = await ref.getDownloadURL();
    }

    // Creating a copy of the doubt with the attachment URL
    final finalDoubt = AcademicDoubt(
      id: doubt.id,
      studentId: doubt.studentId,
      classId: doubt.classId,
      grade: doubt.grade,
      section: doubt.section,
      subject: doubt.subject,
      title: doubt.title,
      description: doubt.description,
      status: doubt.status,
      answer: doubt.answer,
      attachmentUrl: attachmentUrl,
      createdAt: doubt.createdAt,
    );

    await _firestore.collection('doubts').add(finalDoubt.toMap());
  }
}
