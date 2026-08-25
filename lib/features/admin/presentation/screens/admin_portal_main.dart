import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/core/theme/app_theme.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';
import 'package:management/features/admin/presentation/screens/dashboard/admin_dashboard_screen.dart';
import 'package:management/features/admin/presentation/screens/students/admin_students_screen.dart';
import 'package:management/features/admin/presentation/screens/staff/admin_staff_screen.dart';
import 'package:management/features/admin/presentation/screens/exams/admin_exams_screen.dart';
import 'package:management/features/admin/presentation/screens/fees/admin_fees_screen.dart';
import 'package:management/features/admin/presentation/screens/attendance/admin_attendance_screen.dart';

import 'package:google_fonts/google_fonts.dart';

class AdminPortalMain extends StatefulWidget {
  const AdminPortalMain({super.key});

  @override
  State<AdminPortalMain> createState() => _AdminPortalMainState();
}

class _AdminPortalMainState extends State<AdminPortalMain> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminStudentsScreen(),
    const AdminStaffScreen(),
    const AdminExamsScreen(),
    const AdminFeesScreen(),
    const AdminAttendanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 900;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF4F7FC), // Soft portal background
          appBar: isDesktop ? null : AppBar(
            title: Text(
              'Admin Portal',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: const Color(0xFF131742), // Primary Navy
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          drawer: isDesktop ? null : _buildSidebar(isDesktop: false),
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(isDesktop: true),
              Expanded(
                child: Column(
                  children: [
                    if (isDesktop) _buildHeader(),
                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex,
                        children: _screens,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar({required bool isDesktop}) {
    final sidebar = Container(
      width: 280,
      color: const Color(0xFF131742),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE28743),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CITY ADMIN',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Management Portal',
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                children: [
                  _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
                  _buildNavItem(Icons.people_alt_rounded, 'Students', 1),
                  _buildNavItem(Icons.badge_rounded, 'Staff', 2),
                  _buildNavItem(Icons.quiz_rounded, 'Gradebook / Exams', 3),
                  _buildNavItem(Icons.payments_rounded, 'Fees', 4),
                  _buildNavItem(Icons.calendar_month_rounded, 'Attendance', 5),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.logout_rounded, color: Colors.white70),
                title: Text(
                  'Logout',
                  style: GoogleFonts.inter(color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  context.read<AuthProvider>().signOut();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (isDesktop) return sidebar;
    return Drawer(
      backgroundColor: const Color(0xFF131742),
      child: sidebar,
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final bool isSelected = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE28743).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: const Color(0xFFE28743).withOpacity(0.3)) : null,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFFE28743) : Colors.white70,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: () {
          setState(() => _currentIndex = index);
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            'Admin Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // School Selector
          Consumer<AdminProvider>(
            builder: (context, adminProvider, _) {
              return DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: adminProvider.selectedSchoolId,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Schools')),
                      DropdownMenuItem(value: 'city_talent', child: Text('City Talent School')),
                      DropdownMenuItem(value: 'city_elite', child: Text('City Elite School')),
                      DropdownMenuItem(value: 'new_vision', child: Text('New Vision High School')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        adminProvider.setSchoolId(val);
                      }
                    },
                  ),
                ),
              );
            }
          ),
          const SizedBox(width: 24),
          const CircleAvatar(
            backgroundColor: Color(0xFFE28743),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
