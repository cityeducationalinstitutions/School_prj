import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/grade_models.dart';
import 'package:management/features/staff/data/attendance_repository.dart';

class GradeBookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMark(MarksModel mark) async {
    final data = mark.toMap();
    
    // Enrich with Grade/Section metadata for faster future lookups
    try {
      final classDoc = await _firestore.collection('classes').doc(mark.classId).get();
      if (classDoc.exists) {
        data['grade'] = classDoc.data()?['name'];
        data['section'] = (classDoc.data()?['section'] as String?)?.toUpperCase();
      }
    } catch (e) {
      debugPrint('Metadata enrichment failed: $e');
    }

    await _firestore.collection('marks').add(data);
  }

  Future<List<MarksModel>> getMarksByClassAndSubject(String classId, String subject) async {
    final snapshot = await _firestore
        .collection('marks')
        .where('classId', isEqualTo: classId)
        .where('subject', isEqualTo: subject)
        .get();
    return snapshot.docs.map((doc) => MarksModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<MarksModel>> getMarksByClass(String classId) async {
    final List<MarksModel> marks = [];
    
    // Step 1: Search by exact classId
    final snapshot = await _firestore
        .collection('marks')
        .where('classId', isEqualTo: classId)
        .get();
    marks.addAll(snapshot.docs.map((doc) => MarksModel.fromMap(doc.data(), doc.id)));

    // Step 2: Fallback - Fetch marks for all students in this class
    // This resolves "N/A" for marks saved before Class ID stability or name-based tagging
    if (marks.isEmpty) {
      final AttendanceRepository attendanceRepo = AttendanceRepository();
      final students = await attendanceRepo.getStudentsByClass(classId);
      
      if (students.isNotEmpty) {
        final studentIds = students.map((s) => s.id).toList();
        
        // Firestore whereIn limit is 10
        final List<List<String>> chunks = [];
        for (var i = 0; i < studentIds.length; i += 10) {
          chunks.add(studentIds.sublist(i, i + 10 > studentIds.length ? studentIds.length : i + 10));
        }

        for (var chunk in chunks) {
          final fallbackSnapshot = await _firestore.collection('marks')
              .where('studentId', whereIn: chunk)
              .get();
          marks.addAll(fallbackSnapshot.docs.map((doc) => MarksModel.fromMap(doc.data(), doc.id)));
        }
      }
    }

    // De-duplicate Marks by ID
    final Map<String, MarksModel> uniqueMarks = {};
    for (var m in marks) {
      uniqueMarks[m.id] = m;
    }
    return uniqueMarks.values.toList();
  }
}
