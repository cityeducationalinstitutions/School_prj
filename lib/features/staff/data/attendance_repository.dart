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
      debugPrint('Firestore fetch failed (offline mode): $e');
    }
    
    final List<String> grades1to5 = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
    final List<String> grades6to10 = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
    final List<String> sectionsJunior = ['A', 'B', 'C'];
    final List<String> sectionsSenior = ['S1', 'S2', 'Talent', 'Regular'];

    // 1. Filter out classes that don't match the new naming rules (Cleaning legacy data)
    classes = classes.where((c) {
      if (grades1to5.contains(c.name)) {
        return sectionsJunior.contains(c.section);
      }
      if (grades6to10.contains(c.name)) {
        return sectionsSenior.contains(c.section);
      }
      return true; // Keep others
    }).toList();

    // 2. Add missing mock classes
    for (var grade in grades1to5) {
      for (var section in sectionsJunior) {
        if (!classes.any((c) => c.name == grade && c.section == section)) {
          classes.add(ClassModel(
            id: 'mock_${grade.replaceAll(' ', '')}_$section',
            name: grade,
            section: section,
            branchId: schoolId,
          ));
        }
      }
    }
    
    for (var grade in grades6to10) {
      for (var section in sectionsSenior) {
        if (!classes.any((c) => c.name == grade && c.section == section)) {
          classes.add(ClassModel(
            id: 'mock_${grade.replaceAll(' ', '')}_$section',
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
    // If it's an auto-injected mock class, return mock students dynamically
    if (classId.startsWith('mock_')) {
      return List.generate(5, (i) => StudentModel(
        id: '${classId}_student_$i',
        classId: classId,
        name: 'Guest Student ${i+1}',
        rollNo: 'R${i+1}'
      ));
    }
    
    try {
      final snapshot = await _firestore.collection('students').where('classId', isEqualTo: classId).get();
      return snapshot.docs.map((doc) => StudentModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Firestore fetch failed: $e');
      return [];
    }
  }

  Future<void> saveAttendance(AttendanceModel attendance) async {
    final docId = '${attendance.classId}_${attendance.date}_${attendance.sessionType}';
    await _firestore.collection('attendance').doc(docId).set(attendance.toMap(), SetOptions(merge: true));
  }

  Future<AttendanceModel?> getAttendanceRecord(String classId, String date, String sessionType) async {
    final docId = '${classId}_${date}_$sessionType';
    try {
      final doc = await _firestore.collection('attendance').doc(docId).get();
      if (doc.exists && doc.data() != null) {
        return AttendanceModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Firestore fetch record failed: $e');
    }
    return null;
  }

  Future<List<AttendanceModel>> getAttendanceHistory(String classId) async {
    final snapshot = await _firestore.collection('attendance').where('classId', isEqualTo: classId).get();
    return snapshot.docs.map((doc) => AttendanceModel.fromMap(doc.data(), doc.id)).toList();
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
