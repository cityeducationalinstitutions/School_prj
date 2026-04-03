import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/school_model.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  void _showChangePasswordDialog(BuildContext context, Color themeColor) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Change Password', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulate password change
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully!'), behavior: SnackBarBehavior.floating),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('UPDATE', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final selectedSchoolId = authProvider.selectedSchoolId;
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );
    final themeColor = school.themeColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Account Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF131742),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Security'),
            _buildSettingTile(
              Icons.lock_reset_rounded,
              'Change Password',
              'Update your account password regularly',
              onTap: () => _showChangePasswordDialog(context, themeColor),
            ),
            _buildSettingTile(
              Icons.fingerprint_rounded,
              'Biometric Authentication',
              'Use fingerprint or face ID to login',
              trailing: Switch(value: true, onChanged: (v) {}, activeColor: themeColor),
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Notifications'),
            _buildSettingTile(
              Icons.email_outlined,
              'Email Notifications',
              'Receive daily reports via email',
              trailing: Switch(
                value: _emailNotifications, 
                onChanged: (v) => setState(() => _emailNotifications = v),
                activeColor: themeColor,
              ),
            ),
            _buildSettingTile(
              Icons.notifications_active_outlined,
              'Push Notifications',
              'Instant alerts for attendance & leave',
              trailing: Switch(
                value: _pushNotifications, 
                onChanged: (v) => setState(() => _pushNotifications = v),
                activeColor: themeColor,
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionTitle('App Preferences'),
            _buildSettingTile(
              Icons.dark_mode_outlined,
              'Dark Mode',
              'Switch between light and dark themes',
              trailing: Switch(value: false, onChanged: (v) {}, activeColor: themeColor),
            ),
            _buildSettingTile(
              Icons.language_rounded,
              'App Language',
              'English (United States)',
              onTap: () {},
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                'Version 1.0.4 (Build 82)',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF131742),
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF131742).withAlpha(10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF131742), size: 22),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
