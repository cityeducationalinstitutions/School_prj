class MaterialModel {
  final String id;
  final String classId;
  final String title;
  final String fileUrl;
  final String fileName;
  final String uploadedBy;
  final String timestamp;

  MaterialModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.fileUrl,
    required this.fileName,
    required this.uploadedBy,
    required this.timestamp,
  });

  factory MaterialModel.fromMap(Map<String, dynamic> map, String id) {
    return MaterialModel(
      id: id,
      classId: map['classId'] ?? '',
      title: map['title'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileName: map['fileName'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'title': title,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'uploadedBy': uploadedBy,
      'timestamp': timestamp,
    };
  }
}
