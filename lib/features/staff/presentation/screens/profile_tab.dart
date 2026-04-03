import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/school_model.dart';
import 'package:management/features/staff/presentation/screens/profile_edit_screen.dart';
import 'package:management/features/staff/presentation/screens/staff_attendance_screen.dart';
import 'package:management/features/staff/presentation/screens/leave_management_screen.dart';
import 'package:management/features/staff/presentation/screens/account_settings_screen.dart';
import 'package:management/features/staff/presentation/screens/placeholder_screens.dart';

class StaffProfileTab extends StatelessWidget {
  const StaffProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final selectedSchoolId = authProvider.selectedSchoolId;

    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

    final themeColor = school.themeColor;
    final darkNavy = const Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // PREMIUM HEADER WITH BANNER
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [themeColor, themeColor.withAlpha(180)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Profile',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEditScreen())),
                            icon: const Icon(Icons.edit_outlined, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: themeColor.withAlpha(40),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${user?.name ?? "User"}&background=${themeColor.value.toRadixString(16).substring(2)}&color=fff'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // NAME & EMAIL
            Text(
              user?.name ?? 'Staff Member',
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: darkNavy,
              ),
            ),
            Text(
              user?.email ?? 'staff@school.com',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // STATS ROW (KPIs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatItem('Classes', '4', themeColor),
                  _buildStatItem('Attendance', '98%', themeColor, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffAttendanceScreen()));
                  }),
                  _buildStatItem('Leaves', '2', themeColor, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveManagementScreen()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // SETTINGS SECTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Staff Information'),
                  _buildInfoTile(Icons.school_rounded, 'School', school.name, themeColor),
                  _buildInfoTile(Icons.badge_rounded, 'Designation', 'Senior Teacher', themeColor),
                  _buildInfoTile(Icons.category_rounded, 'Department', 'Mathematics', themeColor),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Account Settings'),
                  _buildActionTile(Icons.lock_reset_rounded, 'Security & Password', themeColor, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
                  }),
                  _buildActionTile(Icons.help_outline_rounded, 'Help & Support', themeColor, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderFeatureScreen(title: 'Help & Support')));
                  }),
                  _buildActionTile(Icons.info_outline_rounded, 'About App', themeColor, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderFeatureScreen(title: 'About App')));
                  }),
                  
                  const SizedBox(height: 32),
                  // LOGOUT BUTTON
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                      onPressed: () => authProvider.signOut(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.red.withAlpha(51)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'LOGOUT',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color themeColor, [VoidCallback? onTap]) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF131742),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFF131742),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, Color themeColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF131742),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
