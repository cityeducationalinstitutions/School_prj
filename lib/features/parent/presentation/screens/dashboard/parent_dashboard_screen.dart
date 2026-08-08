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
import 'package:management/models/school_model.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final parentProvider = context.watch<ParentProvider>();
    final parentUser = authProvider.currentUser;
    final selectedSchoolId = authProvider.selectedSchoolId;

    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

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
      body: Column(
        children: [
          _ParentHeaderSection(
            schoolName: school.name,
            themeColor: brandOrange,
            logoPath: school.logoPath,
            provider: parentProvider,
            primaryNavy: primaryNavy,
          ),
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
                      // 1. STUDENT CARD & CHILD SWITCHER
                      _buildStudentInfoCard(context, childName, grade, section, rollNo, parentProvider, primaryNavy, brandOrange),
                      const SizedBox(height: 20),

                      // URGENT ALERTS / ANNOUNCEMENTS SUMMARY
                      if (parentProvider.announcements.isNotEmpty) ...[
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
                        const SizedBox(height: 24),
                      ],

                      // 3. PERFORMANCE BANNER
                      _buildPerformanceBanner(context, overallPct, performanceStatus, primaryNavy, brandOrange),
                      const SizedBox(height: 20),

                      // 4. ATTENDANCE & FEES ROW
                      _buildAttendanceAndFeesRow(context, attendancePct, fee, currencyFormat, primaryNavy, brandOrange),
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

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildStudentInfoCard(
    BuildContext context,
    String studentName,
    String grade,
    String section,
    String rollNo,
    ParentProvider provider,
    Color primaryNavy,
    Color brandOrange,
  ) {
    final bool hasMultipleChildren = provider.linkedChildren.length > 1;

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
          GestureDetector(
            onTap: hasMultipleChildren ? () {
              _showChildSwitcher(context, provider, primaryNavy, brandOrange);
            } : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasMultipleChildren ? primaryNavy.withOpacity(0.08) : brandOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!hasMultipleChildren)
                    const Icon(Icons.school_rounded, color: Color(0xFFE28743), size: 14),
                  if (!hasMultipleChildren) const SizedBox(width: 4),
                  Text(
                    hasMultipleChildren ? 'Switch Child' : 'Student',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: hasMultipleChildren ? primaryNavy : const Color(0xFFE28743),
                    ),
                  ),
                  if (hasMultipleChildren) const SizedBox(width: 4),
                  if (hasMultipleChildren)
                    Icon(Icons.keyboard_arrow_down_rounded, color: primaryNavy, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChildSwitcher(BuildContext context, ParentProvider provider, Color primaryNavy, Color brandOrange) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Child',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              const SizedBox(height: 16),
              ...provider.linkedChildren.map((child) {
                final bool isSelected = provider.currentChild?.uid == child.uid;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? brandOrange : primaryNavy.withOpacity(0.1),
                    child: Text(
                      child.name.isNotEmpty ? child.name[0].toUpperCase() : 'S',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : primaryNavy,
                      ),
                    ),
                  ),
                  title: Text(
                    child.name,
                    style: GoogleFonts.inter(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: primaryNavy,
                    ),
                  ),
                  subtitle: Text('Class ${child.grade} • Section ${child.section}'),
                  trailing: isSelected ? Icon(Icons.check_circle_rounded, color: brandOrange) : null,
                  onTap: () {
                    provider.selectChild(child);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceBanner(
    BuildContext context,
    double overallPct,
    String performanceStatus,
    Color primaryNavy,
    Color brandOrange,
  ) {
    final Color perfColor = performanceStatus == 'Good'
        ? Colors.green.shade400
        : performanceStatus == 'Average'
            ? Colors.amber.shade400
            : Colors.red.shade400;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentPerformanceScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryNavy,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryNavy.withOpacity(0.2),
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
                    'ACADEMIC PERFORMANCE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.65),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${overallPct.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.trending_up_rounded, color: perfColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        performanceStatus.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: perfColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.insights_rounded, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceAndFeesRow(
    BuildContext context,
    double attendancePct,
    FeeRecord? fee,
    NumberFormat format,
    Color primaryNavy,
    Color brandOrange,
  ) {
    final bool hasDue = fee != null && fee.remainingAmount > 0;

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

        // Fees Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentFeesScreen()));
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
                      Icon(Icons.payments_rounded, color: hasDue ? Colors.amber.shade800 : Colors.green, size: 24),
                      Flexible(
                        child: Text(
                          fee == null ? '...' : (hasDue ? format.format(fee.remainingAmount) : 'Paid'),
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: fee == null ? Colors.grey : (hasDue ? Colors.amber.shade900 : Colors.green)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fee Status',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: primaryNavy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fee == null ? 'Loading...' : (hasDue ? 'Dues Pending' : 'Clear'),
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
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
        'title': 'Attendance',
        'subtitle': 'Monthly History',
        'imagePath': 'assets/icons/3d_attendance.png',
        'color': Colors.green.shade700,
        'screen': const ParentAttendanceScreen(),
      },
      {
        'title': 'Marksheets',
        'subtitle': 'Academic Scores',
        'imagePath': 'assets/icons/3d_gradebook.png',
        'color': primaryNavy,
        'screen': const ParentMarksheetsScreen(),
      },
      {
        'title': 'Exam Schedule',
        'subtitle': 'Timetables',
        'imagePath': 'assets/icons/3d_exams.png',
        'color': Colors.purple.shade700,
        'screen': const ParentExamScheduleScreen(),
      },
      {
        'title': 'Performance',
        'subtitle': 'Insights & Stats',
        'imagePath': 'assets/icons/analytics.png',
        'color': Colors.teal.shade700,
        'screen': const ParentPerformanceScreen(),
      },
      {
        'title': 'Circulars',
        'subtitle': 'School Alerts',
        'imagePath': 'assets/icons/announcements.png',
        'color': Colors.blue.shade700,
        'screen': const ParentAnnouncementsScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.82,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final Color itemColor = item['color'] as Color;

        return Container(
          decoration: BoxDecoration(
            color: itemColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: itemColor.withOpacity(0.15), width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                );
              },
              borderRadius: BorderRadius.circular(28),
              splashColor: itemColor.withOpacity(0.2),
              highlightColor: itemColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: itemColor.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          item['imagePath'] as String,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item['title'] as String,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

class _ParentHeaderSection extends StatelessWidget {
  final String schoolName;
  final Color themeColor;
  final String logoPath;
  final ParentProvider provider;
  final Color primaryNavy;

  const _ParentHeaderSection({
    required this.schoolName,
    required this.themeColor,
    required this.logoPath,
    required this.provider,
    required this.primaryNavy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/images/header_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: Stack(
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
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(child: Image.asset(logoPath, fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      schoolName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        letterSpacing: 0.3,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
