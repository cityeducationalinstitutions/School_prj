import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/academic_models.dart';

class StudentGradebookScreen extends StatefulWidget {
  const StudentGradebookScreen({super.key});

  @override
  State<StudentGradebookScreen> createState() => _StudentGradebookScreenState();
}

class _StudentGradebookScreenState extends State<StudentGradebookScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: AppBar(
        title: Text(
          'Academic Record',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: schoolBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: studentProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: schoolOrange, strokeWidth: 3))
          : RefreshIndicator(
              onRefresh: () => studentProvider.fetchDashboardData(),
              color: schoolOrange,
              child: studentProvider.marks.isEmpty
                  ? _buildEmptyEliteState(schoolBlue)
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: _AcademicSummaryHeader(marks: studentProvider.marks),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _EliteGradeCard(mark: studentProvider.marks[index]),
                              childCount: studentProvider.marks.length,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildEmptyEliteState(Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: navy.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment_turned_in_outlined, size: 80, color: navy.withOpacity(0.1)),
          ),
          const SizedBox(height: 32),
          Text(
            'No Academic Records',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Your results and performance analysis will appear here once they are published.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: navy.withOpacity(0.4), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcademicSummaryHeader extends StatelessWidget {
  final List<StudentMark> marks;
  const _AcademicSummaryHeader({required this.marks});

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF131742);
    const Color orange = Color(0xFFE28743);

    double totalObtained = 0;
    double totalMax = 0;
    for (var m in marks) {
      totalObtained += m.marks;
      totalMax += m.totalMarks;
    }
    final overallPercentage = totalMax > 0 ? (totalObtained / totalMax) * 100 : 0.0;
    
    final statusColor = overallPercentage < 60 ? Colors.red.shade400 : Colors.green.shade400;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [orange, orange.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: orange.withOpacity(0.35), blurRadius: 30, offset: const Offset(0, 15)),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      height: 94,
                      width: 94,
                      child: CircularProgressIndicator(
                        value: overallPercentage / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation(statusColor),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          overallPercentage.toStringAsFixed(1),
                          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          '%',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: navy.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'SCHOOL PERFORMANCE',
                          style: GoogleFonts.inter(color: navy, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Performance Record',
                        style: GoogleFonts.outfit(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MiniStat(label: 'MARKS', value: totalObtained.toStringAsFixed(0)),
                          const SizedBox(width: 24),
                          _MiniStat(label: 'TOTAL', value: totalMax.toStringAsFixed(0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Subject Analysis',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 4),
          Text(
            'Academic breakdown by subject',
            style: GoogleFonts.inter(fontSize: 13, color: navy.withOpacity(0.4), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF131742);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: navy)),
      ],
    );
  }
}

class _EliteGradeCard extends StatelessWidget {
  final StudentMark mark;
  const _EliteGradeCard({required this.mark});

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF131742);
    final percentage = mark.totalMarks > 0 ? (mark.marks / mark.totalMarks) * 100 : 0.0;
    final color = _getStatusColor(percentage);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: navy.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.04),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          height: 58,
                          width: 58,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 7,
                            backgroundColor: color.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        ),
                        Text(
                          _getGrade(percentage),
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mark.subject,
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: navy),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              mark.examName.toUpperCase(),
                              style: GoogleFonts.inter(fontSize: 9, color: navy.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${mark.marks.toStringAsFixed(0)}/${mark.totalMarks.toStringAsFixed(0)}',
                          style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: navy),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.stars_rounded, color: color, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage < 60) return Colors.red.shade400;
    return Colors.green.shade400;
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    if (percentage >= 40) return 'D';
    return 'F';
  }
}
