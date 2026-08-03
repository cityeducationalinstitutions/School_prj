import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/dashboard/presentation/screens/school_selection_screen.dart';
import 'package:management/features/parent/presentation/screens/parent_portal_main.dart';
import 'package:management/features/staff/presentation/screens/staff_dashboard.dart';
import 'package:management/features/student/presentation/screens/student_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: Stack(
        children: [
          // Institutional Background Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/header_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Column(
            children: [
              // PREMIUM BRAND HEADER
              const _BrandHeader(title: 'City Educational Institutions'),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  children: [
                   
                    // Welcome Sub-header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user == null ? 'Welcome,' : 'Welcome back,',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user == null ? 'Select Your Portal' : user.name,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF131742),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Portal Selection List
                    _PortalCard(
                      title: 'Staff Portal',
                      description: 'Access the dedicated space for educators to manage classes and students.',
                      imagePath: 'assets/icons/new_role_staff_transparent.png',
                      color: const Color(0xFF131742), // Primary Navy
                      onTap: () => _handleRoleSelection(context, 'staff'),
                    ),
                    _PortalCard(
                      title: 'Student Portal',
                      description: 'The student hub for learning materials, grades, and schedules.',
                      imagePath: 'assets/icons/new_role_student_transparent.png', 
                      color: const Color(0xffB8860B), // Premium Gold
                      onTap: () => _handleRoleSelection(context, 'student'),
                    ),
                    _PortalCard(
                      title: 'Parent Portal',
                      description: 'Stay actively updated with your child\'s academic progress.',
                      imagePath: 'assets/icons/new_role_parent_transparent.png',
                      color: const Color(0xFF388E3C), // Institutional Green
                      onTap: () => _handleRoleSelection(context, 'parent'),
                    ),
                    _PortalCard(
                      title: 'Admin Portal',
                      description: 'High-level school administration and management controls.',
                      imagePath: 'assets/icons/new_role_admin_transparent.png',
                      color: const Color(0xFFD32F2F), // Management Red
                      onTap: () => _handleRoleSelection(context, 'admin'),
                    ),
                    
                    const SizedBox(height: 32),
                    if (user != null)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => authProvider.signOut(),
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text('LOGOUT FROM SYSTEM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade400),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Container(height: 1, width: 40, color: Colors.grey.shade100),
                          const SizedBox(height: 12),
                          Text(
                            'CITY EDUCATION GROUP',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, String role) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    // Explicitly set the chosen role in the provider
    authProvider.setRole(role);

    if (user != null) {
      // If already logged in, navigate based on role choice
      if (role == 'staff') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StaffDashboard()));
      } else if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StudentPortalMain()));
      } else if (role == 'parent') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ParentPortalMain()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role portal is coming soon!')),
        );
      }
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchoolSelectionScreen(role: role),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final String title;
  const _BrandHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xffF9F9F9),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(37.5),
                        child: Image.asset(
                          'assets/images/school_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
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

class _PortalCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  const _PortalCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // REFINED: High-Fidelity 3D Character Avatar Backdrop
                Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: color.withOpacity(0.15), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF131742),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE28743).withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: const Color(0xFFE28743), // School Theme Orange
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

