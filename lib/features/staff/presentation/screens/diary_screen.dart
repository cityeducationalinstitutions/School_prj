import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/diary_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/diary_model.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  ClassModel? _selectedClass;
  String _selectedSubject = 'Mathematics';
  final _topicController = TextEditingController();
  final _homeworkController = TextEditingController();

  final List<String> _subjects = ['Mathematics', 'Science', 'English', 'History'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchClasses();
    });
  }

  void _saveDiary() async {
    if (_selectedClass == null || _topicController.text.isEmpty) return;

    final diary = DiaryModel(
      id: '',
      classId: _selectedClass!.id,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      subject: _selectedSubject,
      topic: _topicController.text,
      homework: _homeworkController.text,
    );

    try {
      await context.read<DiaryProvider>().addEntry(diary);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary entry saved!')),
      );
      _topicController.clear();
      _homeworkController.clear();
      context.read<DiaryProvider>().fetchEntries(_selectedClass!.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final diaryProvider = context.watch<DiaryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Class Diary')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<ClassModel>(
              decoration: const InputDecoration(labelText: 'Select Class'),
              value: _selectedClass,
              items: attendanceProvider.classes.map((c) {
                return DropdownMenuItem(value: c, child: Text('${c.name} - ${c.section}'));
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedClass = val);
                if (val != null) diaryProvider.fetchEntries(val.id);
              },
            ),
            const SizedBox(height: 16),
            if (_selectedClass != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Subject'),
                        value: _selectedSubject,
                        items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) => setState(() => _selectedSubject = val!),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _topicController,
                        decoration: const InputDecoration(labelText: 'Topic Covered'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _homeworkController,
                        decoration: const InputDecoration(labelText: 'Homework Assigned'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: diaryProvider.isLoading ? null : _saveDiary,
                        child: const Text('SAVE ENTRY'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Entries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (diaryProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (diaryProvider.entries.isEmpty)
                const Center(child: Text('No entries found for this class.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: diaryProvider.entries.length,
                    itemBuilder: (context, index) {
                      final entry = diaryProvider.entries[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('${entry.subject} - ${entry.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Topic: ${entry.topic}\nHomework: ${entry.homework}'),
                          isThreeLine: true,
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
