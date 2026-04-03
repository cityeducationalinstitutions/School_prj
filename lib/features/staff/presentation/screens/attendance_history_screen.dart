import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/grade_book_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/school_model.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  ClassModel? _selectedClass;

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
    });
    if (value != null) {
      context.read<AttendanceProvider>().fetchHistory(value.id);
      // Also fetch marks to analyze performance
      context.read<GradeBookProvider>().fetchMarksByClassAndSubject(value.id, 'Mathematics'); // Default subject for analytics
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final gradeProvider = context.watch<GradeBookProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    // Smart Class Selection (Deduplicated & Sorted)
    final classesMap = <String, ClassModel>{};
    for (var c in attendanceProvider.classes) {
      final numGrade = int.tryParse(c.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      bool isValid = false;
      if (numGrade >= 1 && numGrade <= 5) {
        isValid = ['A', 'B', 'C'].contains(c.section);
      } else if (numGrade >= 6 && numGrade <= 10) {
        isValid = ['S1', 'S2', 'Talent', 'Regular'].contains(c.section);
      } else {
        isValid = true;
      }
      
      if (isValid) {
        final key = '${c.name}_${c.section}'.toLowerCase();
        if (!classesMap.containsKey(key)) {
          classesMap[key] = c;
        }
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
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Performance Analysis', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
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
                      _buildDropdown<ClassModel>(
                        label: 'Class',
                        value: _selectedClass,
                        items: sortedClasses,
                        hint: 'Select Class',
                        icon: Icons.analytics_rounded,
                        themeColor: themeColor,
                        itemLabelBuilder: (c) => '${c.name} - ${c.section}',
                        onChanged: _onClassSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (_selectedClass != null) ...[
            SliverToBoxAdapter(
              child: _buildQuickStats(attendanceProvider, gradeProvider, themeColor),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Record Timeline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131742)),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (attendanceProvider.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (attendanceProvider.history.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState('No records found for this class.'),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final record = attendanceProvider.history[index];
                      return _buildHistoryCard(record, themeColor);
                    },
                    childCount: attendanceProvider.history.length,
                  ),
                ),
              ),
          ] else
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('Select a class to begin analysis'),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AttendanceProvider attendance, GradeBookProvider grades, Color themeColor) {
    int totalPresent = 0;
    int totalPossible = 0;
    for (var h in attendance.history) {
      totalPresent += h.studentAttendees.values.where((v) => v).length;
      totalPossible += h.studentAttendees.length;
    }
    final attendancePct = totalPossible > 0 ? (totalPresent / totalPossible * 100).toStringAsFixed(1) : '0';
    
    final passCount = grades.marks.where((m) => m.marksObtained >= 35).length;
    final failCount = grades.marks.where((m) => m.marksObtained >= 0 && m.marksObtained < 35).length;
    final passPct = (passCount + failCount) > 0 ? (passCount / (passCount + failCount) * 100).toStringAsFixed(0) : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _statTile('Attendance', '$attendancePct%', Icons.how_to_reg_rounded, Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _statTile('Pass Ratio', '$passPct%', Icons.auto_graph_rounded, Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(AttendanceModel record, Color themeColor) {
    final present = record.studentAttendees.values.where((v) => v).length;
    final total = record.studentAttendees.length;
    final pct = total > 0 ? (present / total * 100) : 0.0;

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
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(record.date, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                height: 6,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: pct > 80 ? Colors.green : (pct > 50 ? Colors.orange : Colors.red),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$present / $total Present', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.query_stats_rounded, size: 64, color: Colors.grey.shade300),
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
