import 'package:cloud_firestore/cloud_firestore.dart';

class ReportCard {
  final String id;
  final String studentId;
  final String examName;
  final String fileUrl;
  final DateTime createdAt;

  ReportCard({
    required this.id,
    required this.studentId,
    required this.examName,
    required this.fileUrl,
    required this.createdAt,
  });

  factory ReportCard.fromMap(Map<String, dynamic> map, String id) {
    return ReportCard(
      id: id,
      studentId: map['studentId'] ?? '',
      examName: map['examName'] ?? map['title'] ?? 'Report Card',
      fileUrl: map['fileUrl'] ?? map['url'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'examName': examName,
      'fileUrl': fileUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
