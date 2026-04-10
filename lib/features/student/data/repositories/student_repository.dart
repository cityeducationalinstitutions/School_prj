import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:management/features/student/data/models/student_models.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // DIARY
  // DIARY (Synchronized with Staff 'dairy' collection)
  Future<List<StudentDiaryEntry>> getDiaryEntries(String classId, DateTime date) async {
    // Staff records diary using 'dairy' collection and 'classId' filter
    final snapshot = await _firestore
        .collection('dairy')
        .where('classId', isEqualTo: classId)
        .get();
    
    return snapshot.docs
        .map((doc) => StudentDiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // ATTENDANCE
  Future<List<StudentAttendanceRecord>> getAttendance(String studentId, int month, int year) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0);

    final snapshot = await _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    return snapshot.docs
        .map((doc) => StudentAttendanceRecord.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // MATERIALS
  Future<List<StudentMaterial>> getMaterials(String subject) async {
    Query query = _firestore.collection('materials');
    
    if (subject != 'All') {
      query = query.where('subject', isEqualTo: subject);
    }

    final snapshot = await query.orderBy('uploadDate', descending: true).get();
    
    return snapshot.docs
        .map((doc) => StudentMaterial.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // QUIZ
  Future<String> generateQuiz(String materialId, String studentId) async {
    // In production, this would call a Cloud Function
    // Here we simulate the process by creating a quiz document
    
    // 1. Get material keywords
    final materialDoc = await _firestore.collection('materials').doc(materialId).get();
    final materialData = materialDoc.data() as Map<String, dynamic>?;
    final keywords = List<String>.from(materialData?['keywords'] ?? []);
    
    // 2. Fetch questions from questionBank matching keywords
    final questionsSnapshot = await _firestore
        .collection('questionBank')
        .where('tags', arrayContainsAny: keywords.isEmpty ? ['general'] : keywords)
        .limit(10)
        .get();
        
    final questions = questionsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // 3. Create Quiz document
    final quizRef = await _firestore.collection('quizzes').add({
      'studentId': studentId,
      'materialId': materialId,
      'title': 'Quiz: ${materialData?['title'] ?? 'Selected Topic'}',
      'questions': questions,
      'createdAt': FieldValue.serverTimestamp(),
      'score': null,
    });

    return quizRef.id;
  }

  Future<Quiz> getQuiz(String quizId) async {
    final doc = await _firestore.collection('quizzes').doc(quizId).get();
    return Quiz.fromMap(doc.data() as Map<String, dynamic>? ?? {}, doc.id);
  }

  Future<void> submitQuizScore(String quizId, int score) async {
    await _firestore.collection('quizzes').doc(quizId).update({
      'score': score,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // GRADEBOOK
  Future<List<StudentGrade>> getGrades(String studentId) async {
    final snapshot = await _firestore
        .collection('marks')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs.map((doc) => StudentGrade.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // EXAMS
  Future<List<ExamSchedule>> getExamSchedule(String studentId) async {
    // In real app, linked via classId
    final snapshot = await _firestore
        .collection('exams')
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date')
        .get();

    return snapshot.docs
        .map((doc) => ExamSchedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // ANNOUNCEMENTS
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    final snapshot = await _firestore
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }

  // SCHEDULES
  Future<List<ScheduleEntry>> getSchedules(String classId) async {
    final snapshot = await _firestore
        .collection('schedules')
        .where('classId', isEqualTo: classId)
        .get();

    return snapshot.docs
        .map((doc) => ScheduleEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // DOUBTS
  Future<List<StudentDoubt>> getMyDoubts(String studentId) async {
    final snapshot = await _firestore
        .collection('doubts')
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => StudentDoubt.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> raiseDoubt(StudentDoubt doubt, File? attachment) async {
    String? attachmentUrl;

    if (attachment != null) {
      final ref = _storage
          .ref()
          .child('doubts')
          .child('${DateTime.now().millisecondsSinceEpoch}_${doubt.studentId}.jpg');
      
      await ref.putFile(attachment);
      attachmentUrl = await ref.getDownloadURL();
    }

    final doubtData = doubt.toMap();
    if (attachmentUrl != null) {
      doubtData['attachmentUrl'] = attachmentUrl;
    }

    await _firestore.collection('doubts').add(doubtData);
  }

  // NOTIFICATIONS
  Future<List<AppNotification>> getNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AppNotification.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Stream<List<AppNotification>> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
}
