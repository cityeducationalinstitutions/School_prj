import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/grade_book_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/school_model.dart';
import 'package:management/core/widgets/smart_class_selector.dart';

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
      context.read<AttendanceProvider>().fetchStudents(value.id);
      context.read<GradeBookProvider>().fetchMarksByClass(value.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final gradeProvider = context.watch<GradeBookProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    // Grouping logic for history
    final Map<String, List<AttendanceRecord>> groupedHistory = {};
    for (var record in attendanceProvider.history) {
      final dateStr = DateFormat('yyyy-MM-dd').format(record.date);
      final key = '${dateStr}_${record.sessionType}';
      if (!groupedHistory.containsKey(key)) {
        groupedHistory[key] = [];
      }
      groupedHistory[key]!.add(record);
    }
    
    final sortedKeys = groupedHistory.keys.toList()..sort((a, b) => b.compareTo(a));

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
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: SmartClassSelector(
                initialClass: _selectedClass,
                themeColor: themeColor,
                onClassSelected: _onClassSelected,
              ),
            ),
          ),
          
          if (_selectedClass != null) ...[
            SliverToBoxAdapter(
              child: _buildQuickStats(attendanceProvider.history, gradeProvider, themeColor),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Record Timeline',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131742)),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (attendanceProvider.isLoading)
              const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()))
            else if (groupedHistory.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState('No records found for this class.'))
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final key = sortedKeys[index];
                      final records = groupedHistory[key]!;
                      return _buildGroupedHistoryCard(key, records, themeColor);
                    },
                    childCount: sortedKeys.length,
                  ),
                ),
              ),
          ] else
            SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState('Select a class to begin analysis')),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<AttendanceRecord> history, GradeBookProvider grades, Color themeColor) {
    int totalPresent = history.where((r) => r.status == 'Present').length;
    int totalCount = history.length;
    final attendancePct = totalCount > 0 ? (totalPresent / totalCount * 100).toStringAsFixed(1) : '0';
    
    final passCount = grades.marks.where((m) => m.totalMarks > 0 && (m.marksObtained / m.totalMarks) >= 0.35).length;
    final failCount = grades.marks.where((m) => m.totalMarks > 0 && (m.marksObtained / m.totalMarks) < 0.35).length;
    final passPct = (passCount + failCount) > 0 ? (passCount / (passCount + failCount) * 100).toStringAsFixed(0) : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statTile('Attendance', '$attendancePct%', Icons.how_to_reg_rounded, Colors.blue)),
          const SizedBox(width: 16),
          Expanded(child: _statTile('Pass Ratio', '$passPct%', Icons.auto_graph_rounded, Colors.green)),
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

  Widget _buildGroupedHistoryCard(String key, List<AttendanceRecord> records, Color themeColor) {
    // Collect unique student data for this session
    final Map<String, AttendanceRecord> uniqueSessionRecords = {};
    for (var r in records) {
      if (!uniqueSessionRecords.containsKey(r.studentId)) {
        uniqueSessionRecords[r.studentId] = r;
      }
    }

    final present = uniqueSessionRecords.values.where((r) => r.status == 'Present').length;
    final total = uniqueSessionRecords.length;
    final pct = total > 0 ? (present / total * 100) : 0.0;
    
    // Key format is yyyy-MM-dd_SessionType
    final parts = key.split('_');
    final date = parts[0];
    final session = parts.length > 1 ? parts[1] : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        onTap: () => _showRecordDetails(records, themeColor),
        title: Text('$date ($session)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                height: 6,
                width: 100,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(3)),
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

  void _showRecordDetails(List<AttendanceRecord> records, Color themeColor) {
    // De-duplicate records by studentId to handle data inconsistencies
    final Map<String, AttendanceRecord> uniqueRecords = {};
    for (var r in records) {
      if (!uniqueRecords.containsKey(r.studentId)) {
        uniqueRecords[r.studentId] = r;
      }
    }
    final sortedRecords = uniqueRecords.values.toList()
      ..sort((a, b) => a.studentName.compareTo(b.studentName));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                    child: Icon(Icons.people_alt_rounded, color: themeColor),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Attendance Details',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: sortedRecords.length,
                itemBuilder: (context, index) {
                  final record = sortedRecords[index];
                  final isPresent = record.status == 'Present';
                  final isLate = record.status == 'Late';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            record.studentName.isNotEmpty ? record.studentName[0].toUpperCase() : '?',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: themeColor),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            record.studentName,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isPresent ? Colors.green.withOpacity(0.1) : (isLate ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            record.status.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isPresent ? Colors.green : (isLate ? Colors.orange : Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
          Icon(Icons.query_stats_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.inter(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
