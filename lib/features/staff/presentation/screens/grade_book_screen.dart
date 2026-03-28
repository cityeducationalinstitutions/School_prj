import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/staff/presentation/providers/grade_book_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/grade_models.dart';

class GradeBookScreen extends StatefulWidget {
  const GradeBookScreen({super.key});

  @override
  State<GradeBookScreen> createState() => _GradeBookScreenState();
}

class _GradeBookScreenState extends State<GradeBookScreen> {
  ClassModel? _selectedClass;
  String _selectedSubject = 'Mathematics';
  String _selectedExam = 'Quarterly';

  final List<String> _subjects = ['Mathematics', 'Science', 'English', 'History'];
  final List<String> _exams = ['Quarterly', 'Half-Yearly', 'Final', 'Test 1', 'Test 2'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchClasses();
    });
  }

  void _onClassSelected(ClassModel? value) {
    setState(() {
      _selectedClass = value;
    });
    if (value != null) {
      context.read<AttendanceProvider>().fetchStudents(value.id);
      context.read<GradeBookProvider>().fetchMarksByClassAndSubject(value.id, _selectedSubject);
    }
  }

  void _showMarkEntry(BuildContext context, StudentModel student) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Marks for ${student.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Marks obtained'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              final mark = MarksModel(
                id: '',
                studentId: student.id,
                classId: student.classId,
                subject: _selectedSubject,
                examType: _selectedExam,
                marksObtained: double.tryParse(controller.text) ?? 0,
                totalMarks: 100,
              );
              await context.read<GradeBookProvider>().saveMark(mark);
              Navigator.pop(context);
              context.read<GradeBookProvider>().fetchMarksByClassAndSubject(student.classId, _selectedSubject);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final gradeProvider = context.watch<GradeBookProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Grade Book')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<ClassModel>(
              decoration: const InputDecoration(labelText: 'Class'),
              value: _selectedClass,
              items: attendanceProvider.classes.map((c) {
                return DropdownMenuItem(value: c, child: Text('${c.name} - ${c.section}'));
              }).toList(),
              onChanged: _onClassSelected,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Subject'),
                    value: _selectedSubject,
                    items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      setState(() => _selectedSubject = val!);
                      if (_selectedClass != null) {
                        gradeProvider.fetchMarksByClassAndSubject(_selectedClass!.id, _selectedSubject);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Exam'),
                    value: _selectedExam,
                    items: _exams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedExam = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedClass != null) ...[
              if (attendanceProvider.isLoading || gradeProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: attendanceProvider.students.length,
                    itemBuilder: (context, index) {
                      final student = attendanceProvider.students[index];
                      final studentMark = gradeProvider.marks.firstWhere(
                        (m) => m.studentId == student.id && m.examType == _selectedExam,
                        orElse: () => MarksModel(
                          id: '',
                          studentId: student.id,
                          classId: student.classId,
                          subject: _selectedSubject,
                          examType: _selectedExam,
                          marksObtained: -1, // Not entered
                          totalMarks: 100,
                        ),
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(student.name),
                          subtitle: Text('Roll: ${student.rollNo}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: studentMark.marksObtained >= 0 ? Colors.blue.shade100 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              studentMark.marksObtained >= 0 ? studentMark.marksObtained.toString() : 'N/A',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () => _showMarkEntry(context, student),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
