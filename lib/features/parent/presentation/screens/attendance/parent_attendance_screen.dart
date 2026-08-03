import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/attendance_models.dart';

class ParentAttendanceScreen extends StatelessWidget {
  const ParentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final attendanceRecords = parentProvider.attendanceRecords;
    final percentage = parentProvider.attendancePercentage;

    const Color primaryNavy = Color(0xFF131742);
    const Color brandOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Attendance Monitor',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PERCENTAGE HERO CARD
            _buildAttendanceHeroCard(percentage, parentProvider, primaryNavy, brandOrange),
            const SizedBox(height: 24),

            // 2. QUICK METRIC STATS
            Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    'Present',
                    '${parentProvider.presentDaysCount} Days',
                    Colors.green,
                    Icons.check_circle_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatChip(
                    'Absent',
                    '${parentProvider.absentDaysCount} Days',
                    Colors.red,
                    Icons.cancel_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 3. ATTENDANCE HISTORY LIST
            Text(
              'Attendance History',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryNavy,
              ),
            ),
            const SizedBox(height: 12),

            attendanceRecords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = attendanceRecords[index];
                      return _buildAttendanceRecordTile(record, primaryNavy);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceHeroCard(
    double percentage,
    ParentProvider provider,
    Color primaryNavy,
    Color brandOrange,
  ) {
    final bool isHealthy = percentage >= 75.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryNavy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isHealthy ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Attendance',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHealthy ? 'Excellent Attendance!' : 'Attendance Needs Attention',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isHealthy
                      ? 'Student satisfies institutional minimum attendance criteria.'
                      : 'Below minimum 75% attendance criteria. Please contact school administration.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRecordTile(AttendanceRecord record, Color primaryNavy) {
    final bool isPresent = record.status.toLowerCase() == 'present';
    final Color badgeColor = isPresent ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isPresent ? Colors.white : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPresent ? Colors.grey.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPresent ? Icons.check_rounded : Icons.close_rounded,
              color: badgeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(record.date),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPresent ? primaryNavy : Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Session: ${record.sessionType}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isPresent ? Colors.grey.shade600 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record.status.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ],
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
          'No attendance records found for this month.',
          style: GoogleFonts.inter(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
