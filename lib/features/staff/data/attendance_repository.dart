import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ClassModel>> getClasses(String schoolId) async {
    List<ClassModel> classes = [];
    try {
      final snapshot = await _firestore
          .collection('classes')
          .where('branchId', isEqualTo: schoolId)
          .get();
      classes = snapshot.docs.map((doc) => ClassModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Firestore fetch failed: $e');
    }

    // If no classes exist yet, provide the "Universal Institutional Structure" (Default Seeding)
    if (classes.isEmpty) {
      final List<String> juniorGrades = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
      final List<String> seniorGrades = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
      final List<String> juniorSections = ['A', 'B', 'C'];
      final List<String> seniorSections = ['S1', 'S2', 'Talent', 'Regular'];

      for (var grade in juniorGrades) {
        for (var section in juniorSections) {
          classes.add(ClassModel(
            id: 'init_${grade.replaceAll(' ', '')}_$section',
            name: grade,
            section: section,
            branchId: schoolId,
          ));
        }
      }
      for (var grade in seniorGrades) {
        for (var section in seniorSections) {
          classes.add(ClassModel(
            id: 'init_${grade.replaceAll(' ', '')}_$section',
            name: grade,
            section: section,
            branchId: schoolId,
          ));
        }
      }
    }
    return classes;
  }

  Future<List<StudentModel>> getStudentsByClass(String classId) async {
    try {
      // Step 1: Try direct match by classId
      var snapshot = await _firestore
          .collection('users')
          .where('classId', isEqualTo: classId)
          .get();
      
      // Step 2: Fallback - if no students found by ID, try matching by names (Grade/Section)
      // This handles cases where a student signed up using an auto-recovery ID but the teacher is using a real ID.
      if (snapshot.docs.isEmpty) {
        // Find the class details first to get the names
        final classDoc = await _firestore.collection('classes').doc(classId).get();
        if (classDoc.exists) {
          final classData = classDoc.data()!;
          snapshot = await _firestore
              .collection('users')
              .where('grade', isEqualTo: classData['name'])
              .where('section', isEqualTo: classData['section'])
              .get();
        } else if (classId.startsWith('init_')) {
          // If the class itself was an auto-recovery one, parse the names from the ID
          // Format: init_10thGrade_S1
          final parts = classId.split('_');
          if (parts.length >= 3) {
            final grade = parts[1].replaceFirst('Grade', ' Grade'); // '10thGrade' -> '10th Grade'
            final section = parts[2];
            snapshot = await _firestore
                .collection('users')
                .where('grade', isEqualTo: grade)
                .where('section', isEqualTo: section)
                .get();
          }
        }
      }

      return snapshot.docs
          .where((doc) => (doc.data()['roles'] as List?)?.contains('student') ?? false)
          .map((doc) {
        final data = doc.data();
        return StudentModel(
          id: doc.id,
          classId: classId,
          name: data['name'] ?? 'Unknown Student',
          rollNo: data['rollNo'] ?? 'N/A',
        );
      }).toList();
    } catch (e) {
      debugPrint('Firestore student fetch failed: $e');
      return [];
    }
  }

  Future<void> saveAttendance(List<AttendanceRecord> records) async {
    final batch = _firestore.batch();
    for (var record in records) {
      final docId = '${record.studentId}_${record.date.millisecondsSinceEpoch}_${record.sessionType}';
      final docRef = _firestore.collection('attendance').doc(docId);
      batch.set(docRef, record.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<List<AttendanceRecord>> getAttendanceRecord(String classId, DateTime date, String sessionType) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final snapshot = await _firestore
          .collection('attendance')
          .where('classId', isEqualTo: classId)
          .where('sessionType', isEqualTo: sessionType)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();
          
      return snapshot.docs.map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Firestore fetch record failed: $e');
      return [];
    }
  }

  Future<List<AttendanceRecord>> getAttendanceHistory(String classId) async {
    final snapshot = await _firestore
        .collection('attendance')
        .where('classId', isEqualTo: classId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id)).toList();
  }

  // Seeding initial data for Classes and Students for ALL schools
  Future<void> seedData() async {
    final List<String> schoolIds = ['city-talent', 'new-vision', 'city-elite'];
    final List<String> grades1to5 = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
    final List<String> grades6to10 = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
    
    final List<String> sectionsJunior = ['A', 'B', 'C'];
    final List<String> sectionsSenior = ['S1', 'S2', 'Talent', 'Regular'];

    for (var schoolId in schoolIds) {
      // Junior Grades
      for (var grade in grades1to5) {
        for (var section in sectionsJunior) {
          final docRef = await _firestore.collection('classes').add({
            'name': grade,
            'section': section,
            'branchId': schoolId,
          });
          for (int i = 1; i <= 5; i++) {
            await _firestore.collection('students').add({
              'name': 'Student $i ($grade - $section)',
              'classId': docRef.id,
              'rollNo': 'R$i',
            });
          }
        }
      }
      
      // Senior Grades
      for (var grade in grades6to10) {
        for (var section in sectionsSenior) {
          final docRef = await _firestore.collection('classes').add({
            'name': grade,
            'section': section,
            'branchId': schoolId,
          });
          for (int i = 1; i <= 5; i++) {
            await _firestore.collection('students').add({
              'name': 'Student $i ($grade - $section)',
              'classId': docRef.id,
              'rollNo': 'R$i',
            });
          }
        }
      }
    }
  }
}
