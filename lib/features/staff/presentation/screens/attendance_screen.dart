import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedGrade;
  String? _selectedSection;
  ClassModel? _matchingClass;
  
  final Map<String, bool> _attendanceMap = {};
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // These are the sections user requested
  final List<String> _sections = ['s1', 's2', 'Talent', 'regular'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchClasses();
    });
  }

  void _onGradeChanged(String? val) {
    setState(() {
      _selectedGrade = val;
      _matchingClass = null;
      _attendanceMap.clear();
      _selectedSection = null;
    });
  }

  void _onSectionChanged(String? val) {
    setState(() {
      _selectedSection = val;
      _attendanceMap.clear();
    });
    
    _findMatchingClass();
  }

  void _findMatchingClass() {
    if (_selectedGrade == null || _selectedSection == null) return;
    
    final provider = context.read<AttendanceProvider>();
    final match = provider.classes.firstWhere(
      (c) => c.name == _selectedGrade && c.section == _selectedSection,
      orElse: () => ClassModel(id: '', name: '', branchId: '', section: ''),
    );

    if (match.id.isNotEmpty) {
      setState(() => _matchingClass = match);
      provider.fetchStudents(match.id).then((_) {
        for (var student in provider.students) {
          _attendanceMap[student.id] = true;
        }
      });
    } else {
      setState(() => _matchingClass = null);
    }
  }

  void _saveAttendance() async {
    if (_matchingClass == null) return;

    final attendance = AttendanceModel(
      id: '',
      classId: _matchingClass!.id,
      date: _today,
      studentAttendees: _attendanceMap,
    );

    try {
      await context.read<AttendanceProvider>().saveAttendance(attendance);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    
    // Extract unique grades from the classes list
    final grades = provider.classes.map((c) => c.name).toSet().toList();
    grades.sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        actions: [
          if (_matchingClass != null && provider.students.isNotEmpty)
            TextButton(
              onPressed: provider.isLoading ? null : _saveAttendance,
              child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $_today',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (provider.classes.isEmpty && !provider.isLoading)
                  TextButton.icon(
                    onPressed: () => provider.seedInitialData(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Seed Data'),
                    style: TextButton.styleFrom(foregroundColor: Colors.orange),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Dropdown 1: Select Grade/Class Name
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Step 1: Select Grade'),
              value: _selectedGrade,
              items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: _onGradeChanged,
              hint: const Text('Choose Grade (e.g., 6th, 7th)'),
            ),
            
            const SizedBox(height: 16),
            
            // Dropdown 2: Select Section
            if (_selectedGrade != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Step 2: Select Section'),
                value: _selectedSection,
                items: _sections.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: _onSectionChanged,
                hint: const Text('Choose Section (s1, Talent, etc.)'),
              ),

            const SizedBox(height: 32),
            
            if (_matchingClass != null) ...[
              const Text(
                'Students',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.students.isEmpty)
                const Center(child: Text('No students found for this combination.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.students.length,
                    itemBuilder: (context, index) {
                      final student = provider.students[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: SwitchListTile(
                          title: Text(student.name),
                          subtitle: Text('Roll No: ${student.rollNo}'),
                          value: _attendanceMap[student.id] ?? true,
                          onChanged: (val) {
                            setState(() {
                              _attendanceMap[student.id] = val;
                            });
                          },
                          secondary: CircleAvatar(
                            backgroundColor: (_attendanceMap[student.id] ?? true)
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              (_attendanceMap[student.id] ?? true)
                                  ? Icons.check
                                  : Icons.close,
                              color: (_attendanceMap[student.id] ?? true)
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ] else if (_selectedGrade != null && _selectedSection != null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No matching class found in database for this selection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
