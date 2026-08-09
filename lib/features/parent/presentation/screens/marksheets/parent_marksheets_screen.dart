import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/academic_models.dart';

class ParentMarksheetsScreen extends StatelessWidget {
  const ParentMarksheetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final marks = parentProvider.marks;
    final overallPct = parentProvider.overallPercentage;

    const Color primaryNavy = Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Academic Marksheet',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => parentProvider.fetchMarks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OVERALL SCORE SUMMARY HEADER
              _buildOverallScoreCard(overallPct, marks.length, primaryNavy),
              const SizedBox(height: 24),

              Text(
                'Subject-wise Performance Table',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              const SizedBox(height: 12),

              marks.isEmpty
                  ? _buildEmptyState()
                  : _buildMarksTable(marks, primaryNavy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(double overallPct, int totalSubjects, Color primaryNavy) {
    final String gradeBadge = overallPct >= 90
        ? 'A+'
        : overallPct >= 75
            ? 'A'
            : overallPct >= 60
                ? 'B'
                : 'C';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryNavy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OVERALL AGGREGATE',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${overallPct.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Evaluated across $totalSubjects subjects',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GRADE',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    gradeBadge,
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFFFFD54F)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksTable(List<StudentMark> marks, Color primaryNavy) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DataTable(
            headingRowColor: WidgetStateProperty.all(primaryNavy.withOpacity(0.05)),
            columnSpacing: 10,
            horizontalMargin: 12,
            columns: [
            DataColumn(
              label: Text(
                'Subject',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryNavy, fontSize: 11),
                softWrap: false,
              ),
            ),
            DataColumn(
              label: Text(
                'Exam',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryNavy, fontSize: 11),
                softWrap: false,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                'Score',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryNavy, fontSize: 11),
                softWrap: false,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                'Percentage',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryNavy, fontSize: 11),
                softWrap: false,
              ),
            ),
          ],
          rows: marks.map((m) {
            final double pct = m.totalMarks > 0 ? (m.marks / m.totalMarks) * 100 : 0;
            final Color scoreColor = pct >= 75
                ? Colors.green.shade700
                : pct >= 50
                    ? Colors.amber.shade900
                    : Colors.red.shade700;

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    m.subject,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black87),
                    softWrap: false,
                  ),
                ),
                DataCell(
                  Text(
                    m.examName.isNotEmpty ? m.examName : 'Regular',
                    style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade600),
                    softWrap: false,
                  ),
                ),
                DataCell(
                  Text(
                    '${m.marks.toInt()} / ${m.totalMarks.toInt()}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: scoreColor),
                    softWrap: false,
                  ),
                ),
                DataCell(
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: scoreColor),
                    softWrap: false,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          'No marksheets published yet.',
          style: GoogleFonts.inter(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
