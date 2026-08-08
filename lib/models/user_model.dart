class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> roles;
  final String? schoolId; // Nullable for existing/global users, mandatory for new ones
  final String? classId; // Optional class assignment for students
  final String? grade; // Human-readable grade (e.g., 10th)
  final String? section; // Human-readable section (e.g., S1)
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
    this.profileImageUrl,
  });

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
      'profileImageUrl': profileImageUrl,
    };
  }

  bool get isStaff => roles.contains('staff');
  bool get isAdmin => roles.contains('admin');
  bool get isStudent => roles.contains('student');
  bool get isParent => roles.contains('parent');
}
