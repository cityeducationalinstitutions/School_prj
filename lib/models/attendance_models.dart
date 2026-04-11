import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;
  final String name;
  final String branchId;
  final String section;

  ClassModel({
    required this.id,
    required this.name,
    required this.branchId,
    required this.section,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map, String id) {
    return ClassModel(
      id: id,
      name: map['name'] ?? '',
      branchId: map['branchId'] ?? '',
      section: map['section'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'branchId': branchId,
      'section': section,
    };
  }
}

class StudentModel {
  final String id;
  final String name;
  final String classId;
  final String rollNo;

  StudentModel({
    required this.id,
    required this.name,
    required this.classId,
    required this.rollNo,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
    return StudentModel(
      id: id,
      name: map['name'] ?? '',
      classId: map['classId'] ?? '',
      rollNo: map['rollNo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'classId': classId,
      'rollNo': rollNo,
    };
  }
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String classId;
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Late'
  final String sessionType; // 'Morning', 'Evening'

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.date,
    required this.status,
    required this.sessionType,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceRecord(
      id: id,
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      classId: map['classId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? 'Absent',
      sessionType: map['sessionType'] ?? 'Morning',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'classId': classId,
      'date': Timestamp.fromDate(date),
      'status': status,
      'sessionType': sessionType,
    };
  }
}
