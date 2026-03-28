class MarksModel {
  final String id;
  final String studentId;
  final String classId;
  final String subject;
  final String examType; // e.g., Midterm, Final, Class Test
  final double marksObtained;
  final double totalMarks;

  MarksModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.subject,
    required this.examType,
    required this.marksObtained,
    required this.totalMarks,
  });

  factory MarksModel.fromMap(Map<String, dynamic> map, String id) {
    return MarksModel(
      id: id,
      studentId: map['studentId'] ?? '',
      classId: map['classId'] ?? '',
      subject: map['subject'] ?? '',
      examType: map['examType'] ?? '',
      marksObtained: (map['marksObtained'] ?? 0).toDouble(),
      totalMarks: (map['totalMarks'] ?? 100).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'classId': classId,
      'subject': subject,
      'examType': examType,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
    };
  }
}
