import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/screens/attendance_screen.dart';
import 'package:management/features/staff/presentation/screens/attendance_history_screen.dart';
import 'package:management/features/staff/presentation/screens/grade_book_screen.dart';
import 'package:management/features/staff/presentation/screens/diary_screen.dart';
import 'package:management/features/staff/presentation/screens/announcement_screen.dart';
import 'package:management/features/staff/presentation/screens/material_screen.dart';
import 'package:management/features/staff/presentation/screens/exam_management_screen.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/announcement_provider.dart';
import 'package:management/features/staff/presentation/providers/exam_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/school_model.dart';

class StaffHomeTab extends StatelessWidget {
  const StaffHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final selectedSchoolId = authProvider.selectedSchoolId;
    
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // STICKY HEADER
          _HeaderSection(
            schoolName: school.name,
            themeColor: school.themeColor,
            logoPath: school.logoPath,
          ),
          
          // SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24), // Balanced top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // REFINED GREETING CARD - Clean Alignment & Spacing
                    _GreetingCard(
                      name: user?.name ?? 'Staff Member',
                      role: "Let's start the day",
                      themeColor: school.themeColor,
                    ),
                    
                    const SizedBox(height: 32),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.82,
                      children: [
                        _QuickActionCard(
                          title: "Attendance",
                          subtitle: 'Attendance Management',
                          imagePath: 'assets/icons/attendance.png',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Grade Book',
                          subtitle: 'Grade Center',
                          imagePath: 'assets/icons/grades.png',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GradeBookScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Materials & Resources',
                          subtitle: 'Materials & Resources',
                          imagePath: 'assets/icons/materials.png',
                          color: Colors.cyan,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MaterialScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Class Diary',
                          subtitle: 'Class Diary',
                          imagePath: 'assets/icons/diary.png',
                          color: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DiaryScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Attendance History',
                          subtitle: 'Report & Stats',
                          imagePath: 'assets/icons/analytics.png',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceHistoryScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Announcements',
                          subtitle: 'Announcements',
                          imagePath: 'assets/icons/announcements.png',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnnouncementScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionCard(
                          title: 'Exam Scheduling',
                          subtitle: 'Academic Calendar',
                          imagePath: 'assets/icons/exams.png',
                          color: Colors.indigo,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExamManagementScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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

class _HeaderSection extends StatelessWidget {
  final String schoolName;
  final Color themeColor;
  final String logoPath;
  const _HeaderSection({
    required this.schoolName,
    required this.themeColor,
    required this.logoPath,
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
                        border: Border.all(color: Colors.white, width: 2),
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
                    const SizedBox(height: 10),
                    Text(
                      schoolName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
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

class _GreetingCard extends StatelessWidget {
  final String name;
  final String role;
  final Color themeColor;

  const _GreetingCard({
    required this.name,
    required this.role,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF131742);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24), // Fixed, balanced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Good Morning,',
                    style: TextStyle(
                      color: primaryNavy.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('☀️', style: TextStyle(fontSize: 20)),
                ],
              ),
              Icon(
                Icons.wb_sunny_rounded,
                color: themeColor.withOpacity(0.15),
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 12), // Added proper spacing
          Text(
            name,
            style: TextStyle(
              color: themeColor,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16), // Added proper spacing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role.toUpperCase(),
              style: TextStyle(
                color: themeColor,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imagePath;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: imagePath != null
                      ? Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                        )
                      : Icon(Icons.category_rounded, color: color, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 15,
                    height: 1.2,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
