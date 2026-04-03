class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> roles;
  final String? schoolId; // Nullable for existing/global users, mandatory for new ones

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.roles,
    this.schoolId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      roles: List<String>.from(map['roles'] ?? []),
      schoolId: map['schoolId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'roles': roles,
      'schoolId': schoolId,
    };
  }

  bool get isStaff => roles.contains('staff');
  bool get isAdmin => roles.contains('admin');
  bool get isStudent => roles.contains('student');
  bool get isParent => roles.contains('parent');
}
