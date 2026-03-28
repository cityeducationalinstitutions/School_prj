import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/auth/presentation/screens/login_screen.dart';
import 'package:management/features/staff/presentation/screens/staff_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is already logged in and authenticated
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('School Management'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => authProvider.signOut(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              user == null ? 'Welcome' : 'Welcome back, ${user.name}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              user == null 
                ? 'Select your portal to log in'
                : 'Choose a portal to proceed',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _RoleCard(
                    title: 'Staff Portal',
                    icon: Icons.assignment_ind_rounded,
                    color: Colors.blue.shade700,
                    onTap: () => _handleRoleSelection(context, 'staff', Colors.blue.shade700),
                  ),
                  _RoleCard(
                    title: 'Student Portal',
                    icon: Icons.school_rounded,
                    color: Colors.orange.shade700,
                    onTap: () => _handleRoleSelection(context, 'student', Colors.orange.shade700),
                  ),
                  _RoleCard(
                    title: 'Parent Portal',
                    icon: Icons.family_restroom_rounded,
                    color: Colors.green.shade700,
                    onTap: () => _handleRoleSelection(context, 'parent', Colors.green.shade700),
                  ),
                  _RoleCard(
                    title: 'Admin Portal',
                    icon: Icons.admin_panel_settings_rounded,
                    color: Colors.red.shade700,
                    onTap: () => _handleRoleSelection(context, 'admin', Colors.red.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, String role, Color color) {
    final user = context.read<AuthProvider>().currentUser;
    
    // If already logged in, check permission and navigate directly
    if (user != null) {
      if (user.roles.contains(role)) {
        if (role == 'staff') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$role portal is coming soon!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission Denied: You do not have the $role role.'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
      return;
    }

    // Otherwise, go to login for that specific role
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(requiredRole: role, roleColor: color),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
