import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/features/parent/presentation/screens/announcements/parent_announcements_screen.dart';
import 'package:management/features/parent/presentation/screens/attendance/parent_attendance_screen.dart';
import 'package:management/features/parent/presentation/screens/diary/parent_diary_screen.dart';
import 'package:management/features/parent/presentation/screens/exams/parent_exam_schedule_screen.dart';
import 'package:management/features/parent/presentation/screens/fees/parent_fees_screen.dart';
import 'package:management/features/parent/presentation/screens/marksheets/parent_marksheets_screen.dart';
import 'package:management/features/parent/presentation/screens/notifications/parent_notifications_screen.dart';
import 'package:management/features/parent/presentation/screens/performance/parent_performance_screen.dart';
import 'package:management/features/parent/presentation/screens/reportcards/parent_report_cards_screen.dart';
import 'package:management/models/fee_model.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final parentProvider = context.watch<ParentProvider>();
    final parentUser = authProvider.currentUser;

    final childName = parentProvider.childName;
    final grade = parentProvider.grade;
    final section = parentProvider.section;
    final rollNo = parentProvider.rollNo;
    final fee = parentProvider.feeRecord;
    final attendancePct = parentProvider.attendancePercentage;
    final performanceStatus = parentProvider.performanceStatus;
    final overallPct = parentProvider.overallPercentage;
    final isLoading = parentProvider.isLoading;

    const Color primaryNavy = Color(0xFF131742);
    const Color brandOrange = Color(0xFFE28743);

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Loading indicator at top
            if (isLoading)
              const LinearProgressIndicator(
                backgroundColor: Color(0xFFE8E8E8),
                valueColor: AlwaysStoppedAnimation<Color>(brandOrange),
                minHeight: 3,
              ),

            // Main scrollable content — always renders all sections
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => parentProvider.initializeData(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. TOP HEADER WITH NOTIFICATION BELL
                      _buildHeader(context, parentUser?.name ?? 'Parent', parentProvider, primaryNavy),
                      const SizedBox(height: 20),

                      // 2. STUDENT CARD & CHILD SWITCHER
                      _buildStudentInfoCard(childName, grade, section, rollNo, parentProvider, primaryNavy, brandOrange),
                      const SizedBox(height: 20),

                      // 3. REMAINING FEE DUES BANNER
                      if (fee != null)
                        _buildRemainingFeeBanner(context, fee, currencyFormat, primaryNavy)
                      else
                        _buildFeePlaceholder(context, primaryNavy),

                      const SizedBox(height: 20),

                      // 4. METRICS ROW (Attendance % & Performance Badge)
                      _buildMetricsRow(context, attendancePct, performanceStatus, overallPct, primaryNavy, brandOrange),
                      const SizedBox(height: 24),

                      // 5. QUICK ACTIONS GRID
                      Text(
                        'Parent Dashboard Controls',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildQuickActionsGrid(context, primaryNavy, brandOrange),
                      const SizedBox(height: 24),

                      // 6. URGENT ALERTS / ANNOUNCEMENTS SUMMARY
                      Text(
                        'Recent School Alerts',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRecentAlertsSection(context, parentProvider, primaryNavy),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String parentName, ParentProvider provider, Color primaryNavy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PARENT PORTAL',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Welcome, $parentName',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryNavy,
              ),
            ),
          ],
        ),
          ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParentNotificationsScreen()),
                );
              },
              icon: const Icon(Icons.notifications_none_rounded, size: 28),
              color: primaryNavy,
            ),
            if (provider.unreadNotificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${provider.unreadNotificationCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentInfoCard(
    String studentName,
    String grade,
    String section,
    String rollNo,
    ParentProvider provider,
    Color primaryNavy,
    Color brandOrange,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: primaryNavy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Class $grade • Section $section  (Roll No: $rollNo)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: brandOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_rounded, color: Color(0xFFE28743), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Student',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFE28743)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingFeeBanner(
    BuildContext context,
    FeeRecord fee,
    NumberFormat format,
    Color primaryNavy,
  ) {
    final bool hasDue = fee.remainingAmount > 0;
    final Color bannerBg = hasDue ? const Color(0xFF131742) : Colors.green.shade800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bannerBg.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REMAINING FEE BALANCES',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasDue ? format.format(fee.remainingAmount) : 'Fully Paid 🎉',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: hasDue ? const Color(0xFFFFD54F) : Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hasDue ? 'Due Date: ${DateFormat('dd MMM yyyy').format(fee.dueDate)}' : 'No outstanding dues',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentFeesScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE28743),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('View Fees'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(
    BuildContext context,
    double attendancePct,
    String performanceStatus,
    double overallPct,
    Color primaryNavy,
    Color brandOrange,
  ) {
    final Color perfColor = performanceStatus == 'Good'
        ? Colors.green.shade700
        : performanceStatus == 'Average'
            ? Colors.amber.shade900
            : Colors.red.shade700;

    return Row(
      children: [
        // Attendance Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentAttendanceScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.event_available_rounded, color: Colors.green, size: 24),
                      Text(
                        '${attendancePct.toStringAsFixed(1)}%',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Attendance Rate',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: primaryNavy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    attendancePct >= 75 ? 'Satisfactory' : 'Action Required',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Performance Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentPerformanceScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.insights_rounded, color: Color(0xFFE28743), size: 24),
                      Text(
                        '${overallPct.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: perfColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Performance',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: primaryNavy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    performanceStatus,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: perfColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, Color primaryNavy, Color brandOrange) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Fee Details',
        'icon': Icons.account_balance_wallet_rounded,
        'color': Colors.amber.shade800,
        'screen': const ParentFeesScreen(),
      },
      {
        'title': 'Report Cards',
        'icon': Icons.picture_as_pdf_rounded,
        'color': const Color(0xFFD32F2F),
        'screen': const ParentReportCardsScreen(),
      },
      {
        'title': 'Attendance',
        'icon': Icons.calendar_month_rounded,
        'color': Colors.green.shade700,
        'screen': const ParentAttendanceScreen(),
      },
      {
        'title': 'Marksheets',
        'icon': Icons.table_chart_rounded,
        'color': primaryNavy,
        'screen': const ParentMarksheetsScreen(),
      },
      {
        'title': 'Digital Diary',
        'icon': Icons.menu_book_rounded,
        'color': brandOrange,
        'screen': const ParentDiaryScreen(),
      },
      {
        'title': 'Exam Schedule',
        'icon': Icons.event_note_rounded,
        'color': Colors.purple.shade700,
        'screen': const ParentExamScheduleScreen(),
      },
      {
        'title': 'Performance',
        'icon': Icons.analytics_rounded,
        'color': Colors.teal.shade700,
        'screen': const ParentPerformanceScreen(),
      },
      {
        'title': 'Circulars',
        'icon': Icons.campaign_rounded,
        'color': Colors.blue.shade700,
        'screen': const ParentAnnouncementsScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        mainAxisExtent: 94,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final Color itemColor = item['color'] as Color;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['screen'] as Widget),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: itemColor.withOpacity(0.15)),
                ),
                child: Icon(item['icon'] as IconData, color: itemColor, size: 24),
              ),
              const SizedBox(height: 4),
              Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: primaryNavy,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentAlertsSection(BuildContext context, ParentProvider provider, Color primaryNavy) {
    final announcements = provider.announcements.take(2).toList();
    if (announcements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text('No urgent school alerts right now.', style: GoogleFonts.inter(color: Colors.grey.shade500)),
        ),
      );
    }

    return Column(
      children: announcements.map((a) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE28743).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_rounded, color: Color(0xFFE28743), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.title,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: primaryNavy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeePlaceholder(BuildContext context, Color primaryNavy) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FEE DUES & PAYMENTS',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.65),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Loading Dues...',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentFeesScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE28743),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View Fees'),
          ),
        ],
      ),
    );
  }
}
