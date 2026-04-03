import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/grade_book_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/grade_models.dart';
import 'package:management/models/school_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/staff/data/grade_book_pdf_service.dart';

class GradeBookScreen extends StatefulWidget {
  const GradeBookScreen({super.key});

  @override
  State<GradeBookScreen> createState() => _GradeBookScreenState();
}

class _GradeBookScreenState extends State<GradeBookScreen> {
  ClassModel? _selectedClass;
  String _selectedSubject = 'Mathematics';
  String _selectedExam = 'Quarterly';
  String _searchQuery = '';

  final List<String> _subjects = ['Telugu', 'Hindi', 'English', 'Mathematics', 'Physical Science','Biological Science','Chemistry','Social Studies'];
  final List<String> _exams = ['Weekly Test','Quarterly', 'Half-Yearly', 'Final'];

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

  void _onClassSelected(ClassModel? value) {
    setState(() {
      _selectedClass = value;
      _searchQuery = '';
    });
    if (value != null) {
      context.read<AttendanceProvider>().fetchStudents(value.id);
      context.read<GradeBookProvider>().fetchMarksByClassAndSubject(value.id, _selectedSubject);
    }
  }

  void _showMarkEntry(BuildContext context, StudentModel student, Color themeColor) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Enter Marks: ${student.name}',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Exam: $_selectedExam | Subject: $_selectedSubject',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Marks obtained',
                hintText: 'e.g., 85',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: themeColor, width: 2)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('CANCEL', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
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
              if (context.mounted) {
                Navigator.pop(context);
                context.read<GradeBookProvider>().fetchMarksByClassAndSubject(student.classId, _selectedSubject);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('SAVE MARKS', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final gradeProvider = context.watch<GradeBookProvider>();
    final selectedSchoolId = context.watch<AuthProvider>().selectedSchoolId;
    
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );
    final themeColor = school.themeColor;

    // Sorting & Filtering & De-duplicating Classes for Premium Experience
    final classesMap = <String, ClassModel>{};
    for (var c in attendanceProvider.classes) {
      final key = '${c.name}_${c.section}'.toLowerCase();
      if (!classesMap.containsKey(key)) {
        classesMap[key] = c;
      }
    }
    
    final sortedClasses = classesMap.values.toList();

    sortedClasses.sort((a, b) {
      final numA = int.tryParse(a.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (numA != numB) return numA.compareTo(numB);
      return a.section.compareTo(b.section);
    });

    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text('Grade Book', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
        actions: [
          if (_selectedClass != null && !attendanceProvider.isLoading && !gradeProvider.isLoading) ...[
            IconButton(
              icon: Icon(Icons.file_download_rounded, color: themeColor),
              onPressed: () {
                GradeBookPdfService.downloadMarksSheet(
                  school: school,
                  clazz: _selectedClass!,
                  subject: _selectedSubject,
                  examType: _selectedExam,
                  students: attendanceProvider.students,
                  marks: gradeProvider.marks,
                );
              },
              tooltip: 'Download Marks Sheet',
            ),
            IconButton(
              icon: Icon(Icons.picture_as_pdf_rounded, color: themeColor),
              onPressed: () {
                GradeBookPdfService.generateMarksSheet(
                  school: school,
                  clazz: _selectedClass!,
                  subject: _selectedSubject,
                  examType: _selectedExam,
                  students: attendanceProvider.students,
                  marks: gradeProvider.marks,
                );
              },
              tooltip: 'Print/Preview Marks Sheet',
            ),
          ],
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Filter Card
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildDropdown(
                    label: 'Class',
                    value: _selectedClass,
                    items: sortedClasses,
                    hint: 'Select Class',
                    icon: Icons.class_rounded,
                    themeColor: themeColor,
                    onChanged: _onClassSelected,
                    itemLabelBuilder: (c) => '${c.name} - ${c.section}',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Subject',
                          value: _selectedSubject,
                          items: _subjects,
                          hint: 'Subject',
                          icon: Icons.book_rounded,
                          themeColor: themeColor,
                          compact: true,
                          onChanged: (val) {
                            setState(() => _selectedSubject = val!);
                            if (_selectedClass != null) {
                              gradeProvider.fetchMarksByClassAndSubject(_selectedClass!.id, _selectedSubject);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Exam',
                          value: _selectedExam,
                          items: _exams,
                          hint: 'Exam',
                          icon: Icons.assignment_rounded,
                          themeColor: themeColor,
                          compact: true,
                          onChanged: (val) => setState(() => _selectedExam = val!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Student List
          if (_selectedClass != null) ...[
            if (attendanceProvider.isLoading || gradeProvider.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded, color: themeColor),
                        hintText: 'Search students...',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),

              (() {
                final filteredStudents = attendanceProvider.students.where((s) {
                  final q = _searchQuery.toLowerCase();
                  return s.name.toLowerCase().contains(q) || s.rollNo.toLowerCase().contains(q);
                }).toList();

                if (filteredStudents.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No students found', style: GoogleFonts.inter(color: Colors.grey))),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final student = filteredStudents[index];
                        final studentMark = gradeProvider.marks.firstWhere(
                          (m) => m.studentId == student.id && m.examType == _selectedExam,
                          orElse: () => MarksModel(
                            id: '', studentId: student.id, classId: student.classId,
                            subject: _selectedSubject, examType: _selectedExam,
                            marksObtained: -1, totalMarks: 100,
                          ),
                        );

                        final isEntered = studentMark.marksObtained >= 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor: isEntered ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                              child: Icon(
                                isEntered ? Icons.check_circle_rounded : Icons.pending_rounded,
                                color: isEntered ? Colors.green : Colors.grey,
                              ),
                            ),
                            title: Text(student.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF131742))),
                            subtitle: Text('Roll No: ${student.rollNo}', style: GoogleFonts.inter(color: Colors.grey)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isEntered ? themeColor.withOpacity(0.1) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isEntered ? studentMark.marksObtained.toStringAsFixed(0) : 'PENDING',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isEntered ? themeColor : Colors.grey),
                              ),
                            ),
                            onTap: () => _showMarkEntry(context, student, themeColor),
                          ),
                        );
                      },
                      childCount: filteredStudents.length,
                    ),
                  ),
                );
              })(),
            ],
          ] else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_note_rounded, size: 64, color: Colors.grey.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text(
                      'Select a Class, Subject and Exam\nto start entering marks',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
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
    bool compact = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: compact ? 10 : 12),
          prefixIcon: Icon(icon, color: themeColor, size: compact ? 18 : 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16, vertical: 8),
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600, size: compact ? 18 : 24),
        value: value,
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabelBuilder != null ? itemLabelBuilder(item) : item.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600, 
              color: const Color(0xFF131742),
              fontSize: compact ? 13 : 14,
            ),
          ),
        )).toList(),
        onChanged: onChanged,
        hint: Text(
          hint, 
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: compact ? 12 : 14),
        ),
      ),
    );
  }
}
