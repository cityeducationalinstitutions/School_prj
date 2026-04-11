import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/exam_provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/school_model.dart';

class ExamManagementScreen extends StatefulWidget {
  const ExamManagementScreen({super.key});

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen> {
  ClassModel? _selectedClass;
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schoolId = context.read<AuthProvider>().selectedSchoolId;
      if (schoolId != null) {
        context.read<AttendanceProvider>().fetchClasses(schoolId);
      }
    });
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveExam() async {
    if (_selectedClass == null || _titleController.text.isEmpty || _subjectController.text.isEmpty) return;

    final exam = AcademicExam(
      id: '',
      classId: _selectedClass!.id,
      grade: _selectedClass!.name,
      section: _selectedClass!.section,
      subject: _subjectController.text,
      date: _selectedDate,
      time: '09:00 AM', // Default
      type: _titleController.text, // Mapped examTitle to type
    );

    try {
      await context.read<StaffExamProvider>().createExam(exam);
      _titleController.clear();
      _subjectController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam scheduled successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final examProvider = context.watch<StaffExamProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    final sortedClasses = attendanceProvider.classes.toList(); // Simplified sorting for now
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Exam Scheduling', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _buildDropdown<ClassModel>(
                          label: 'Class',
                          value: _selectedClass,
                          items: sortedClasses,
                          hint: 'Select Class',
                          icon: Icons.school_rounded,
                          themeColor: themeColor,
                          itemLabelBuilder: (c) => '${c.name} - ${c.section}',
                          onChanged: (val) {
                            setState(() => _selectedClass = val);
                            if (val != null) examProvider.fetchExams(val.name, val.section);
                          },
                        ),
                        if (_selectedClass != null) ...[
                          const SizedBox(height: 16),
                          _buildEntryForm(themeColor, examProvider),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_selectedClass != null) ...[
            if (examProvider.isLoading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final exam = examProvider.exams[index];
                      return _buildExamCard(exam, themeColor, examProvider);
                    },
                    childCount: examProvider.exams.length,
                  ),
                ),
              ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildEntryForm(Color themeColor, StaffExamProvider provider) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Exam Title (e.g. Finals)', icon: Icon(Icons.title, color: themeColor)),
        ),
        TextField(
          controller: _subjectController,
          decoration: InputDecoration(labelText: 'Subject', icon: Icon(Icons.book, color: themeColor)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.calendar_today, color: themeColor),
          title: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
          trailing: TextButton(onPressed: _selectDate, child: const Text('SELECT DATE')),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: provider.isLoading ? null : _saveExam,
            style: ElevatedButton.styleFrom(backgroundColor: themeColor),
            child: const Text('SCHEDULE EXAM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildExamCard(AcademicExam exam, Color themeColor, StaffExamProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(exam.type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${exam.subject} • ${DateFormat('dd MMM').format(exam.date)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => provider.deleteExam(exam.id, exam.grade, exam.section),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required Color themeColor,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabelBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: themeColor)),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(itemLabelBuilder!(i)))).toList(),
      onChanged: onChanged,
    );
  }
}
