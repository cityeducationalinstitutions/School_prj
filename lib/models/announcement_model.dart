class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String targetRole; // e.g., 'staff', 'student', 'all'
  final String date;
  final String author;
  final String schoolId;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.targetRole,
    required this.date,
    required this.author,
    required this.schoolId,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      targetRole: map['targetRole'] ?? 'all',
      date: map['date'] ?? '',
      author: map['author'] ?? '',
      schoolId: map['schoolId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'targetRole': targetRole,
      'date': date,
      'author': author,
      'schoolId': schoolId,
    };
  }
}
