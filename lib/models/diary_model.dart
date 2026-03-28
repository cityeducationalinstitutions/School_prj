class DiaryModel {
  final String id;
  final String classId;
  final String subject;
  final String topic;
  final String homework;
  final String date;

  DiaryModel({
    required this.id,
    required this.classId,
    required this.subject,
    required this.topic,
    required this.homework,
    required this.date,
  });

  factory DiaryModel.fromMap(Map<String, dynamic> map, String id) {
    return DiaryModel(
      id: id,
      classId: map['classId'] ?? '',
      subject: map['subject'] ?? '',
      topic: map['topic'] ?? '',
      homework: map['homework'] ?? '',
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'subject': subject,
      'topic': topic,
      'homework': homework,
      'date': date,
    };
  }
}
