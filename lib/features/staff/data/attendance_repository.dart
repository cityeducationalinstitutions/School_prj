import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ClassModel>> getClasses() async {
    final snapshot = await _firestore.collection('classes').get();
    return snapshot.docs.map((doc) => ClassModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<StudentModel>> getStudentsByClass(String classId) async {
    final snapshot = await _firestore.collection('students').where('classId', isEqualTo: classId).get();
    return snapshot.docs.map((doc) => StudentModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> saveAttendance(AttendanceModel attendance) async {
    await _firestore.collection('attendance').add(attendance.toMap());
  }

  Future<List<AttendanceModel>> getAttendanceHistory(String classId) async {
    final snapshot = await _firestore.collection('attendance').where('classId', isEqualTo: classId).get();
    return snapshot.docs.map((doc) => AttendanceModel.fromMap(doc.data(), doc.id)).toList();
  }

  // Seeding initial data for Classes and Students
  Future<void> seedData() async {
    final List<String> grades = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
    final List<String> sections = ['s1', 's2', 'Talent', 'regular'];

    for (var grade in grades) {
      for (var section in sections) {
        final docRef = await _firestore.collection('classes').add({
          'name': grade,
          'section': section,
          'branchId': 'main',
        });

        // Add 5 placeholder students for each class
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
