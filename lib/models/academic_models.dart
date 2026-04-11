import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String id;
  final String classId;
  final String grade;
  final String section;
  final String subject;
  final String topic;
  final String homework;
  final DateTime date;

  DiaryEntry({
    required this.id,
    required this.classId,
    required this.grade,
    required this.section,
    required this.subject,
    required this.topic,
    required this.homework,
    required this.date,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> map, String id) {
    return DiaryEntry(
      id: id,
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      topic: map['topic'] ?? '',
      homework: map['homework'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'grade': grade,
      'section': section,
      'subject': subject,
      'topic': topic,
      'homework': homework,
      'date': Timestamp.fromDate(date),
    };
  }
}

class AcademicMaterial {
  final String id;
  final String classId;
  final String grade;
  final String section;
  final String subject;
  final String title;
  final String fileUrl;
  final DateTime createdAt;

  AcademicMaterial({
    required this.id,
    required this.classId,
    required this.grade,
    required this.section,
    required this.subject,
    required this.title,
    required this.fileUrl,
    required this.createdAt,
  });

  factory AcademicMaterial.fromMap(Map<String, dynamic> map, String id) {
    return AcademicMaterial(
      id: id,
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      title: map['title'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'grade': grade,
      'section': section,
      'subject': subject,
      'title': title,
      'fileUrl': fileUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Announcement {
  final String id;
  final String classId;
  final String grade;
  final String section;
  final String title;
  final String message;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.classId,
    required this.grade,
    required this.section,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> map, String id) {
    return Announcement(
      id: id,
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'grade': grade,
      'section': section,
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class StudentMark {
  final String id;
  final String studentId;
  final String subject;
  final String examName;
  final double marks;
  final double totalMarks;

  StudentMark({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.examName,
    required this.marks,
    required this.totalMarks,
  });

  factory StudentMark.fromMap(Map<String, dynamic> map, String id) {
    return StudentMark(
      id: id,
      studentId: map['studentId'] ?? '',
      subject: map['subject'] ?? '',
      examName: map['examName'] ?? '',
      marks: (map['marks'] ?? 0).toDouble(),
      totalMarks: (map['totalMarks'] ?? 100).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'subject': subject,
      'examName': examName,
      'marks': marks,
      'totalMarks': totalMarks,
    };
  }
}

class ClassPeriod {
  final String id;
  final String classId;
  final String grade;
  final String section;
  final String day;
  final String subject;
  final String startTime;
  final String endTime;
  final String teacherName;
  final String? room;

  ClassPeriod({
    required this.id,
    required this.classId,
    required this.grade,
    required this.section,
    required this.day,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.teacherName,
    this.room,
  });

  factory ClassPeriod.fromMap(Map<String, dynamic> map, String id) {
    return ClassPeriod(
      id: id,
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      day: map['day'] ?? '',
      subject: map['subject'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      teacherName: map['teacherName'] ?? '',
      room: map['room'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'grade': grade,
      'section': section,
      'day': day,
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      'teacherName': teacherName,
      'room': room,
    };
  }
}

class AcademicExam {
  final String id;
  final String classId;
  final String grade;
  final String section;
  final String subject;
  final DateTime date;
  final String time;
  final String type;
  final String? room;

  AcademicExam({
    required this.id,
    required this.classId,
    required this.grade,
    required this.section,
    required this.subject,
    required this.date,
    required this.time,
    required this.type,
    this.room,
  });

  factory AcademicExam.fromMap(Map<String, dynamic> map, String id) {
    return AcademicExam(
      id: id,
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      type: map['type'] ?? 'Unit Test',
      room: map['room'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'grade': grade,
      'section': section,
      'subject': subject,
      'date': Timestamp.fromDate(date),
      'time': time,
      'type': type,
      'room': room,
    };
  }
}

class AcademicDoubt {
  final String id;
  final String studentId;
  final String classId;
  final String grade;
  final String section;
  final String subject;
  final String title;
  final String description;
  final String status;
  final String? answer;
  final String? attachmentUrl;
  final DateTime createdAt;

  AcademicDoubt({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.grade,
    required this.section,
    required this.subject,
    required this.title,
    required this.description,
    required this.status,
    this.answer,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory AcademicDoubt.fromMap(Map<String, dynamic> map, String id) {
    return AcademicDoubt(
      id: id,
      studentId: map['studentId'] ?? '',
      classId: map['classId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      answer: map['answer'],
      attachmentUrl: map['attachmentUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'classId': classId,
      'grade': grade,
      'section': section,
      'subject': subject,
      'title': title,
      'description': description,
      'status': status,
      'answer': answer,
      'attachmentUrl': attachmentUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map, String id) {
    return AppNotification(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'general',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }
}
