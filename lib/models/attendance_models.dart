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

class AttendanceModel {
  final String id;
  final String classId;
  final String date; // YYYY-MM-DD
  final Map<String, bool> studentAttendees; // studentId: isPresent

  AttendanceModel({
    required this.id,
    required this.classId,
    required this.date,
    required this.studentAttendees,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      classId: map['classId'] ?? '',
      date: map['date'] ?? '',
      studentAttendees: Map<String, bool>.from(map['studentAttendees'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'date': date,
      'studentAttendees': studentAttendees,
    };
  }
}
