import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getDashboardStats(String schoolId) async {
    int totalStudents = 0;
    int totalTeachers = 0;
    int totalParents = 0;
    int totalClasses = 0;
    
    try {
      Query studentsQuery = _firestore.collection('users').where('roles', arrayContains: 'student');
      Query teachersQuery = _firestore.collection('users').where('roles', arrayContains: 'staff');
      Query parentsQuery = _firestore.collection('users').where('roles', arrayContains: 'parent');
      Query classesQuery = _firestore.collection('classes');

      if (schoolId != 'all') {
        studentsQuery = studentsQuery.where('schoolId', isEqualTo: schoolId);
        teachersQuery = teachersQuery.where('schoolId', isEqualTo: schoolId);
        parentsQuery = parentsQuery.where('schoolId', isEqualTo: schoolId);
        classesQuery = classesQuery.where('schoolId', isEqualTo: schoolId);
      }

      final studentCount = await studentsQuery.count().get();
      totalStudents = studentCount.count ?? 0;

      final teacherCount = await teachersQuery.count().get();
      totalTeachers = teacherCount.count ?? 0;

      final parentCount = await parentsQuery.count().get();
      totalParents = parentCount.count ?? 0;

      final classCount = await classesQuery.count().get();
      totalClasses = classCount.count ?? 0;

    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }

    return {
      'students': totalStudents,
      'teachers': totalTeachers,
      'parents': totalParents,
      'classes': totalClasses,
    };
  }
}
