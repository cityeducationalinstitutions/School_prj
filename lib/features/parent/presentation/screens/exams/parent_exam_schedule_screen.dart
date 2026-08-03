import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/academic_models.dart';

class ParentExamScheduleScreen extends StatelessWidget {
  const ParentExamScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final exams = parentProvider.exams;

    const Color primaryNavy = Color(0xFF131742);
    const Color brandOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Upcoming Exam Schedule',
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
        onRefresh: () => parentProvider.fetchExams(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Term & Examination Timetable',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              const SizedBox(height: 14),

              exams.isEmpty
                  ? _buildEmptyExamsState()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exams.length,
                      itemBuilder: (context, index) {
                        final exam = exams[index];
                        return _buildExamCard(exam, primaryNavy, brandOrange);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(AcademicExam exam, Color primaryNavy, Color brandOrange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: brandOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: brandOrange.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('MMM').format(exam.date).toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: brandOrange),
                  ),
                  Text(
                    DateFormat('dd').format(exam.date),
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: primaryNavy),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.subject,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        exam.time,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.room_rounded, size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Room: ${exam.room ?? "Main Exam Hall"} • ${exam.type}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyExamsState() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          'No upcoming examinations scheduled.',
          style: GoogleFonts.inter(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
