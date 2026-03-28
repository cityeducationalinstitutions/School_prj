import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/core/theme/app_theme.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/auth/presentation/screens/splash_screen.dart';
import 'package:management/features/dashboard/presentation/screens/role_selection_screen.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/grade_book_provider.dart';
import 'package:management/features/staff/presentation/providers/diary_provider.dart';
import 'package:management/features/staff/presentation/providers/announcement_provider.dart';
import 'package:management/features/staff/presentation/providers/material_provider.dart';
import 'package:management/features/staff/presentation/screens/staff_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => GradeBookProvider()),
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management Super App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Show splash for 3 seconds, then naturally navigate forward
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = authProvider.currentUser;

    if (user != null) {
      // Automatic routing: If already logged in, show the correct dashboard
      if (user.roles.contains('admin')) {
        return const RoleSelectionScreen(); // Admins see selection (they can choose portals)
      } else if (user.roles.contains('staff')) {
        return const StaffDashboard();
      } else {
        return const RoleSelectionScreen(); 
      }
    }

    // Role selection is the starting point for everyone else
    return const RoleSelectionScreen();
  }
}
