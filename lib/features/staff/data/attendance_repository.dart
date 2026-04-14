import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ClassModel>> getClasses(String schoolId) async {
    List<ClassModel> classes = [];
    try {
      final snapshot = await _firestore
          .collection('classes')
          .where('branchId', isEqualTo: schoolId)
          .get();
      final allFetched = snapshot.docs.map((doc) => ClassModel.fromMap(doc.data(), doc.id)).toList();
      
      if (schoolId == 'city-talent') {
        classes = allFetched.where((c) {
          // Parse numerical grade (e.g., "1st Grade" -> 1)
          final gradeMatch = RegExp(r'(\d+)').firstMatch(c.name);
          final gradeNum = gradeMatch != null ? int.tryParse(gradeMatch.group(1)!) : null;
          
          if (gradeNum == null) return true; // Keep if we can't parse it (Fallback)

          final section = c.section.toUpperCase();
          
          if (gradeNum >= 1 && gradeNum <= 5) {
            return ['A', 'B', 'C'].contains(section);
          } else if (gradeNum >= 6 && gradeNum <= 10) {
            return ['S1', 'S2', 'TALENT', 'REGULAR'].contains(section);
          }
          return true;
        }).toList();
      } else {
        classes = allFetched;
      }
    } catch (e) {
      debugPrint('Firestore fetch failed: $e');
    }

    // If no classes exist yet, provide the "Institutional Logic" (Default Seeding)
    if (classes.isEmpty) {
      final List<String> grades1to5 = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
      final List<String> grades6to10 = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
      
      if (schoolId == 'city-talent') {
        const juniorSections = ['A', 'B', 'C'];
        const seniorSections = ['S1', 'S2', 'Talent', 'Regular'];

        for (var grade in grades1to5) {
          for (var section in juniorSections) {
            classes.add(ClassModel(id: 'init_${grade.replaceAll(' ', '')}_$section', name: grade, section: section, branchId: schoolId));
          }
        }
        for (var grade in grades6to10) {
          for (var section in seniorSections) {
            classes.add(ClassModel(id: 'init_${grade.replaceAll(' ', '')}_$section', name: grade, section: section, branchId: schoolId));
          }
        }
      } else {
        // New Vision / City Elite - No multiple sections required
        final allGrades = [...grades1to5, ...grades6to10];
        for (var grade in allGrades) {
          classes.add(ClassModel(id: 'init_${grade.replaceAll(' ', '')}_A', name: grade, section: 'A', branchId: schoolId));
        }
      }
    }
    return classes;
  }

  Future<List<StudentModel>> getStudentsByClass(String classId) async {
    try {
      final List<StudentModel> allStudents = [];
      
      // Step 1: Direct match by classId
      final idSnapshot = await _firestore
          .collection('users')
          .where('classId', isEqualTo: classId)
          .get();
      
      allStudents.addAll(idSnapshot.docs
          .where((doc) => (doc.data()['roles'] as List?)?.contains('student') ?? false)
          .map((doc) => StudentModel(
            id: doc.id,
            classId: classId,
            name: doc.data()['name'] ?? 'Unknown Student',
            rollNo: doc.data()['rollNo'] ?? 'N/A',
          )));

      // Step 2: Extract Grade/Section details
      String? targetGrade;
      String? targetSection;
      String? branchId;

      final classDoc = await _firestore.collection('classes').doc(classId).get();
      if (classDoc.exists) {
        targetGrade = classDoc.data()?['name'];
        targetSection = (classDoc.data()?['section'] as String?)?.toLowerCase();
        branchId = classDoc.data()?['branchId'];
      } else if (classId.startsWith('init_')) {
        final parts = classId.split('_');
        if (parts.length >= 3) {
          targetGrade = parts[1].replaceFirst('Grade', ' Grade');
          targetSection = parts[2].toLowerCase();
        }
      }

      // Step 3: Flexible Fallback matching
      if (targetGrade != null && targetSection != null) {
        // Handle "10th" vs "10th Grade" mismatches
        final List<String> gradeVariants = [targetGrade];
        if (targetGrade.contains('Grade')) {
          gradeVariants.add(targetGrade.replaceAll(' Grade', '').trim());
        } else {
          gradeVariants.add('$targetGrade Grade');
        }

        for (var variant in gradeVariants) {
          var query = _firestore.collection('users').where('grade', isEqualTo: variant);
          if (branchId != null) query = query.where('schoolId', isEqualTo: branchId);
          
          final nameSnapshot = await query.get();
          allStudents.addAll(nameSnapshot.docs
              .where((doc) {
                final data = doc.data();
                final isStudent = (data['roles'] as List?)?.contains('student') ?? false;
                final studentSection = (data['section'] as String? ?? '').toLowerCase();
                return isStudent && studentSection == targetSection;
              })
              .map((doc) => StudentModel(
                id: doc.id,
                classId: classId,
                name: doc.data()['name'] ?? 'Unknown Student',
                rollNo: doc.data()['rollNo'] ?? 'N/A',
              )));
        }
      }

      // Final Step: De-duplicate by student ID
      final Map<String, StudentModel> uniqueStudents = {};
      for (var s in allStudents) {
        uniqueStudents[s.id] = s;
      }
      return uniqueStudents.values.toList();
    } catch (e) {
      debugPrint('Firestore student fetch failed: $e');
      return [];
    }
  }

  Future<void> saveAttendance(List<AttendanceRecord> records) async {
    if (records.isEmpty) return;
    
    final batch = _firestore.batch();
    
    // Fetch class metadata to enrich records
    String? grade;
    String? section;
    final classDoc = await _firestore.collection('classes').doc(records.first.classId).get();
    if (classDoc.exists) {
      grade = classDoc.data()?['name'];
      section = (classDoc.data()?['section'] as String?)?.toUpperCase();
    }

    for (var record in records) {
      final normalizedDate = DateTime(record.date.year, record.date.month, record.date.day);
      final docId = '${record.studentId}_${normalizedDate.millisecondsSinceEpoch}_${record.sessionType}';
      
      final docRef = _firestore.collection('attendance').doc(docId);
      
      final data = record.toMap();
      data['date'] = Timestamp.fromDate(normalizedDate);
      if (grade != null) data['grade'] = grade;
      if (section != null) {
        final upperSec = section.toUpperCase().trim();
        if (['S1', 'S2', 'TALENT', 'REGULAR'].contains(upperSec)) {
          data['section'] = upperSec == 'TALENT' ? 'Talent' : (upperSec == 'REGULAR' ? 'Regular' : upperSec);
        } else {
          data['section'] = upperSec;
        }
      }
      
      batch.set(docRef, data, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<List<AttendanceRecord>> getAttendanceRecord(String classId, DateTime date, String sessionType) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    try {
      final snapshot = await _firestore.collection('attendance')
          .where('classId', isEqualTo: classId)
          .where('date', isEqualTo: Timestamp.fromDate(startOfDay))
          .where('sessionType', isEqualTo: sessionType)
          .get();

      return snapshot.docs
          .map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Firestore fetch record failed: $e');
      return [];
    }
  }

  Future<List<AttendanceRecord>> getAttendanceHistory(String classId) async {
    final List<AttendanceRecord> history = [];
    
    // Step 1: Exact classId match
    final snapshot = await _firestore
        .collection('attendance')
        .where('classId', isEqualTo: classId)
        .get();
    history.addAll(snapshot.docs.map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id)));

    // Step 2: Fallback - Fetch records for all students in this class
    // This catches records saved before the Class ID was stable or synced
    if (history.isEmpty) {
      final students = await getStudentsByClass(classId);
      if (students.isNotEmpty) {
        final studentIds = students.map((s) => s.id).toList();
        
        // Firestore whereIn limit is 10, but for class-size fallback this is usually sufficient
        // For larger classes, we could batch the query if needed
        final List<List<String>> chunks = [];
        for (var i = 0; i < studentIds.length; i += 10) {
          chunks.add(studentIds.sublist(i, i + 10 > studentIds.length ? studentIds.length : i + 10));
        }

        for (var chunk in chunks) {
          final fallbackSnapshot = await _firestore.collection('attendance')
              .where('studentId', whereIn: chunk)
              .get();
          history.addAll(fallbackSnapshot.docs.map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id)));
        }
      }
    }

    // De-duplicate records by ID
    final Map<String, AttendanceRecord> uniqueHistory = {};
    for (var r in history) {
      uniqueHistory[r.id] = r;
    }
    return uniqueHistory.values.toList();
  }

  // Seeding initial data for Classes and Students for ALL schools
  Future<void> seedData() async {
    final List<String> schoolIds = ['city-talent', 'new-vision', 'city-elite'];
    final List<String> grades1to5 = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
    final List<String> grades6to10 = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];
    
    final List<String> sectionsJunior = ['A', 'B', 'C'];
    final List<String> sectionsSenior = ['S1', 'S2', 'Talent', 'Regular'];

    for (var schoolId in schoolIds) {
      final List<String> grades1to5 = ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade', '5th Grade'];
      final List<String> grades6to10 = ['6th Grade', '7th Grade', '8th Grade', '9th Grade', '10th Grade'];

      void addClassAndStudents(String grade, List<String> currSections) async {
        for (var section in currSections) {
          final docRef = await _firestore.collection('classes').add({
            'name': grade,
            'section': section,
            'branchId': schoolId,
          });
          for (int i = 1; i <= 5; i++) {
            await _firestore.collection('students').add({
              'name': 'Student $i ($grade - $section)',
              'classId': docRef.id,
              'rollNo': 'R$i',
            });
          }
        }
      }

      if (schoolId == 'city-talent') {
        for (var grade in grades1to5) addClassAndStudents(grade, ['A', 'B', 'C']);
        for (var grade in grades6to10) addClassAndStudents(grade, ['S1', 'S2', 'Talent', 'Regular']);
      } else {
        for (var grade in [...grades1to5, ...grades6to10]) addClassAndStudents(grade, ['A']);
      }
    }
  }
}
