import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/core/theme/app_theme.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';
import 'package:management/features/admin/presentation/screens/dashboard/admin_dashboard_screen.dart';
import 'package:management/features/admin/presentation/screens/students/admin_students_screen.dart';
import 'package:management/features/admin/presentation/screens/staff/admin_staff_screen.dart';
import 'package:management/features/admin/presentation/screens/academics/admin_academics_screen.dart';
import 'package:management/features/admin/presentation/screens/exams/admin_exams_screen.dart';
import 'package:management/features/admin/presentation/screens/fees/admin_fees_screen.dart';
import 'package:management/features/admin/presentation/screens/attendance/admin_attendance_screen.dart';

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
    const AdminAcademicsScreen(),
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
            title: const Text('Admin Portal'),
            backgroundColor: const Color(0xFF131742), // Primary Navy
            foregroundColor: Colors.white,
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
      width: 250,
      color: const Color(0xFF131742),
      child: Column(
        children: [
          if (isDesktop)
            Container(
              height: 70,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'CITY ADMIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
                _buildNavItem(Icons.people_alt_rounded, 'Students', 1),
                _buildNavItem(Icons.badge_rounded, 'Staff', 2),
                _buildNavItem(Icons.menu_book_rounded, 'Academics', 3),
                _buildNavItem(Icons.quiz_rounded, 'Exams', 4),
                _buildNavItem(Icons.payments_rounded, 'Fees', 5),
                _buildNavItem(Icons.calendar_month_rounded, 'Attendance', 6),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: const Text('Logout', style: TextStyle(color: Colors.white70)),
            onTap: () {
              context.read<AuthProvider>().signOut();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    if (isDesktop) return sidebar;
    return Drawer(child: sidebar);
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final bool isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFE28743) : Colors.white70, // Orange accent
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
      onTap: () {
        setState(() => _currentIndex = index);
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
      },
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
