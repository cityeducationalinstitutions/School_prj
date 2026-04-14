import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/diary_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/school_model.dart';
import 'package:management/core/widgets/smart_class_selector.dart';

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
  String? _editingId;

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _topicController.clear();
      _homeworkController.clear();
      _selectedSubject = 'Mathematics';
    });
  }

  final List<String> _subjects = [
    'Telugu', 'Hindi', 'English', 'Mathematics', 
    'Physical Science', 'Biological Science', 'Chemistry', 'Social Studies'
  ];

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

  void _saveDiary() async {
    if (_selectedClass == null || _topicController.text.isEmpty) return;
    final provider = context.read<DiaryProvider>();

    final diary = DiaryEntry(
      id: _editingId ?? '',
      classId: _selectedClass!.id,
      grade: _selectedClass!.name,
      section: _selectedClass!.section,
      date: _editingId != null 
          ? provider.entries.firstWhere((e) => e.id == _editingId).date
          : DateTime.now(),
      subject: _selectedSubject,
      topic: _topicController.text,
      homework: _homeworkController.text,
    );

    try {
      final messenger = ScaffoldMessenger.of(context);
      if (_editingId != null) {
        await provider.updateEntry(diary);
        messenger.showSnackBar(const SnackBar(content: Text('Diary entry updated!')));
      } else {
        await provider.addEntry(diary);
        messenger.showSnackBar(const SnackBar(content: Text('Diary entry saved!')));
      }
      
      _cancelEdit();
      provider.fetchEntries(_selectedClass!.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _editEntry(DiaryEntry entry) {
    setState(() {
      _editingId = entry.id;
      _selectedSubject = entry.subject;
      _topicController.text = entry.topic;
      _homeworkController.text = entry.homework;
    });
  }

  void _deleteEntry(String id) async {
    if (_selectedClass == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: const Text('Are you sure you want to delete this lesson entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

  if (confirm == true) {
      try {
        await context.read<DiaryProvider>().deleteEntry(id, _selectedClass!.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lesson deleted!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryProvider = context.watch<DiaryProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Class Diary', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // PREMIUM FILTER CARD
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _editingId != null ? 'Edit Lesson Entry' : 'Record New Lesson', 
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                          ),
                          if (_editingId != null)
                            TextButton(
                              onPressed: _cancelEdit,
                              child: Text('Cancel', style: TextStyle(color: themeColor)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SmartClassSelector(
                        initialClass: _selectedClass,
                        themeColor: themeColor,
                        onClassSelected: (val) {
                          setState(() => _selectedClass = val);
                          if (val != null) diaryProvider.fetchEntries(val.id);
                        },
                      ),
                      if (_selectedClass != null) ...[
                        const SizedBox(height: 16),
                        _buildDiaryForm(themeColor, diaryProvider),
                      ],
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lesson Timeline',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131742)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          if (_selectedClass == null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('Select a class to view lessons'),
            )
          else if (diaryProvider.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (diaryProvider.entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('No lessons recorded yet.'),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = diaryProvider.entries[index];
                    return _buildDiaryCard(entry, themeColor);
                  },
                  childCount: diaryProvider.entries.length,
                ),
              ),
            ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildDiaryForm(Color themeColor, DiaryProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildDropdown<String>(
            label: 'Subject',
            value: _selectedSubject,
            items: _subjects,
            hint: 'Choose Subject',
            icon: Icons.book_rounded,
            themeColor: themeColor,
            onChanged: (val) => setState(() => _selectedSubject = val!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _topicController,
            decoration: InputDecoration(
              labelText: 'Topic Covered',
              labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(Icons.title_rounded, color: themeColor),
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          TextField(
            controller: _homeworkController,
            decoration: InputDecoration(
              labelText: 'Homework Assigned',
              labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(Icons.assignment_rounded, color: themeColor),
              border: InputBorder.none,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _saveDiary,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: provider.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_editingId != null ? 'UPDATE LESSON' : 'SAVE LESSON', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryCard(DiaryEntry entry, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.subject.toUpperCase(),
                    style: GoogleFonts.inter(color: themeColor, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                Text(
                  DateFormat('dd MMM, yyyy').format(entry.date),
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              entry.topic,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742), fontSize: 16),
            ),
            if (entry.homework.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.assignment_turned_in_rounded, size: 14, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Homework: ${entry.homework}',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                  onPressed: () => _editEntry(entry),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  onPressed: () => _deleteEntry(entry.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.inter(color: Colors.grey.shade500)),
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
          labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
          prefixIcon: Icon(icon, color: themeColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
        value: value,
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabelBuilder != null ? itemLabelBuilder(item) : item.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
          ),
        )).toList(),
        onChanged: onChanged,
        hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14)),
      ),
    );
  }
}
