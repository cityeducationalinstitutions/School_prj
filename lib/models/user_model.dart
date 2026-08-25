class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> roles;
  final String? schoolId; // Nullable for existing/global users, mandatory for new ones
  final String? classId; // Optional class assignment for students
  final String? grade; // Human-readable grade (e.g., 10th)
  final String? section; // Human-readable section (e.g., S1)
  final String? rollNo; // Roll number in class (e.g., 01, 02)
  final String? studentId; // Formatted Admission/Student ID (e.g., NV-9S2-01)
  final double? decidedFee; // Agreed admission fee amount
  final String? subject; // Subject specialization for faculty (e.g., Mathematics)
  final String? phone; // Phone / Mobile contact number
  final String? profileImageUrl; // URL for the user's profile picture

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.roles,
    this.schoolId,
    this.classId,
    this.grade,
    this.section,
    this.rollNo,
    this.studentId,
    this.decidedFee,
    this.subject,
    this.phone,
    this.profileImageUrl,
  });

  String get displayRollNo {
    if (rollNo != null && rollNo!.isNotEmpty) return rollNo!;
    final int hashVal = (uid.hashCode.abs() % 35) + 1;
    return hashVal.toString().padLeft(2, '0');
  }

  String get displayStudentId {
    if (studentId != null && studentId!.isNotEmpty) {
      return studentId!.replaceAll(RegExp(r'^[A-Za-z]+-'), '').replaceAll('-', '');
    }
    final cleanGrade = (grade ?? '9').replaceAll(RegExp(r'[^0-9]'), '');
    final cleanSec = (section ?? 'A').replaceAll('Section ', '').replaceAll('Sec ', '').replaceAll(':', '').trim();
    return '$cleanGrade$cleanSec$displayRollNo';
  }

  String get displaySubject {
    if (subject != null && subject!.isNotEmpty) return subject!;
    return 'General Faculty';
  }

  String get displayPhone {
    if (phone != null && phone!.isNotEmpty) return phone!;
    return 'Not provided';
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      roles: List<String>.from(map['roles'] ?? []),
      schoolId: map['schoolId'],
      classId: map['classId'],
      grade: map['grade'],
      section: map['section'],
      rollNo: map['rollNo'],
      studentId: map['studentId'],
      decidedFee: (map['decidedFee'] != null) ? (map['decidedFee'] as num).toDouble() : null,
      subject: map['subject'] ?? map['teachingSubject'],
      phone: map['phone'] ?? map['phoneNumber'] ?? map['mobile'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'roles': roles,
      'schoolId': schoolId,
      'classId': classId,
      'grade': grade,
      'section': section,
      'rollNo': rollNo ?? displayRollNo,
      'studentId': studentId ?? displayStudentId,
      'decidedFee': decidedFee,
      'subject': subject,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }

  bool get isStaff => roles.contains('staff');
  bool get isAdmin => roles.contains('admin');
  bool get isStudent => roles.contains('student');
  bool get isParent => roles.contains('parent');
}
