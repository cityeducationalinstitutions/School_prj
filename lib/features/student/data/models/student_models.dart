import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDiaryEntry {
  final String id;
  final String subject;
  final String topic;
  final String homework;
  final DateTime date;

  StudentDiaryEntry({
    required this.id,
    required this.subject,
    required this.topic,
    required this.homework,
    required this.date,
  });

  factory StudentDiaryEntry.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate;
    if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is String) {
      parsedDate = DateTime.tryParse(map['date']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return StudentDiaryEntry(
      id: id,
      subject: map['subject'] ?? '',
      topic: map['topic'] ?? '',
      homework: map['homework'] ?? '',
      date: parsedDate,
    );
  }
}

class StudentAttendanceRecord {
  final DateTime date;
  final String status; // 'present', 'absent', 'late'

  StudentAttendanceRecord({
    required this.date,
    required this.status,
  });

  factory StudentAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceRecord(
      date: (map['date'] as dynamic)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'present',
    );
  }
}

class StudentMaterial {
  final String id;
  final String subject;
  final String title;
  final String pdfUrl;
  final List<String> keywords;
  final DateTime uploadDate;

  StudentMaterial({
    required this.id,
    required this.subject,
    required this.title,
    required this.pdfUrl,
    required this.keywords,
    required this.uploadDate,
  });

  factory StudentMaterial.fromMap(Map<String, dynamic> map, String id) {
    return StudentMaterial(
      id: id,
      subject: map['subject'] ?? '',
      title: map['title'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      keywords: List<String>.from(map['keywords'] ?? []),
      uploadDate: (map['uploadDate'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final String materialId;
  final List<Question> questions;
  final int? score;

  Quiz({
    required this.id,
    required this.title,
    required this.materialId,
    required this.questions,
    this.score,
  });

  factory Quiz.fromMap(Map<String, dynamic> map, String id) {
    return Quiz(
      id: id,
      title: map['title'] ?? 'Generated Quiz',
      materialId: map['materialId'] ?? '',
      questions: (map['questions'] as List? ?? [])
          .map((q) => Question.fromMap(q))
          .toList(),
      score: map['score'],
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}

class StudentGrade {
  final String subject;
  final String examName;
  final double obtainedMarks;
  final double totalMarks;

  StudentGrade({
    required this.subject,
    required this.examName,
    required this.obtainedMarks,
    required this.totalMarks,
  });

  factory StudentGrade.fromMap(Map<String, dynamic> map) {
    return StudentGrade(
      subject: map['subject'] ?? '',
      examName: map['examName'] ?? '',
      obtainedMarks: (map['obtainedMarks'] ?? 0).toDouble(),
      totalMarks: (map['totalMarks'] ?? 0).toDouble(),
    );
  }
}

class ExamSchedule {
  final String id;
  final String subject;
  final DateTime date;
  final TimeOfDay time;
  final String? room;
  final String type; // 'MT', 'SA', 'FA', 'Practical'

  ExamSchedule({
    required this.id,
    required this.subject,
    required this.date,
    required this.time,
    required this.type,
    this.room,
  });

  factory ExamSchedule.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = (map['date'] as dynamic)?.toDate() ?? DateTime.now();
    return ExamSchedule(
      id: id,
      subject: map['subject'] ?? '',
      date: timestamp,
      time: TimeOfDay(hour: timestamp.hour, minute: timestamp.minute),
      type: map['type'] ?? 'Exam',
      room: map['room'],
    );
  }
}

class ScheduleEntry {
  final String id;
  final String classId;
  final String day;
  final String subject;
  final String startTime;
  final String endTime;
  final String? teacherName;
  final String? room;

  ScheduleEntry({
    required this.id,
    required this.classId,
    required this.day,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.teacherName,
    this.room,
  });

  factory ScheduleEntry.fromMap(Map<String, dynamic> map, String id) {
    return ScheduleEntry(
      id: id,
      classId: map['classId'] ?? '',
      day: map['day'] ?? '',
      subject: map['subject'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      teacherName: map['teacherName'],
      room: map['room'],
    );
  }
}

class StudentDoubt {
  final String id;
  final String studentId;
  final String subject;
  final String? teacherId;
  final String title;
  final String description;
  final String? attachmentUrl;
  final String status; // 'pending' | 'in_progress' | 'resolved'
  final String? reply;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentDoubt({
    required this.id,
    required this.studentId,
    required this.subject,
    this.teacherId,
    required this.title,
    required this.description,
    this.attachmentUrl,
    required this.status,
    this.reply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentDoubt.fromMap(Map<String, dynamic> map, String id) {
    return StudentDoubt(
      id: id,
      studentId: map['studentId'] ?? '',
      subject: map['subject'] ?? '',
      teacherId: map['teacherId'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      attachmentUrl: map['attachmentUrl'],
      status: map['status'] ?? 'pending',
      reply: map['reply'],
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'subject': subject,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'attachmentUrl': attachmentUrl,
      'status': status,
      'reply': reply,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'announcement' | 'exam' | 'attendance' | 'doubt'
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map, String id) {
    return AppNotification(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'general',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}

class StudentAssignment {
  final String id;
  final String subject;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status; // 'pending' | 'completed'

  StudentAssignment({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  factory StudentAssignment.fromMap(Map<String, dynamic> map, String id) {
    return StudentAssignment(
      id: id,
      subject: map['subject'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}
