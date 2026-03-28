import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/grade_models.dart';

class GradeBookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMark(MarksModel mark) async {
    await _firestore.collection('marks').add(mark.toMap());
  }

  Future<List<MarksModel>> getMarksByClassAndSubject(String classId, String subject) async {
    final snapshot = await _firestore
        .collection('marks')
        .where('classId', isEqualTo: classId)
        .where('subject', isEqualTo: subject)
        .get();
    return snapshot.docs.map((doc) => MarksModel.fromMap(doc.data(), doc.id)).toList();
  }
}
