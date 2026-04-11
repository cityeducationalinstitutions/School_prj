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
import 'package:management/features/staff/presentation/providers/staff_activity_provider.dart';
import 'package:management/features/staff/presentation/providers/exam_provider.dart';
import 'package:management/features/staff/presentation/screens/staff_dashboard.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/features/student/presentation/screens/student_dashboard.dart';

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
        ChangeNotifierProvider(create: (_) => StaffActivityProvider()),
        ChangeNotifierProvider(create: (_) => StaffExamProvider()),
        ChangeNotifierProxyProvider<AuthProvider, StudentProvider>(
          create: (context) => StudentProvider(
            studentId: '',
            classId: null,
            grade: null,
            section: null,
          ),
          update: (context, auth, previous) => StudentProvider(
            studentId: auth.currentUser?.uid ?? '',
            classId: auth.currentUser?.classId,
            grade: auth.currentUser?.grade,
            section: auth.currentUser?.section,
          ),
        ),
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
      title: 'City Educational Institutions',
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

    if (authProvider.isInitialCheck) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = authProvider.currentUser;

    if (user != null) {
      // 1. If we have an explicitly chosen role (e.g. from RoleSelectionScreen), prioritize it
      if (authProvider.selectedRole != null) {
        if (authProvider.selectedRole == 'student') return const StudentPortalMain();
        if (authProvider.selectedRole == 'staff') return const StaffDashboard();
      }

      // 2. Fallback: If we have a selected school and it's a student/staff, we can go direct
      if (authProvider.selectedSchoolId != null) {
        if (user.isStudent) return const StudentPortalMain();
        if (user.isStaff) return const StaffDashboard();
      }

      // Default fallback to Role Selection if ambiguous
      return const RoleSelectionScreen();
    }

    // Unauthenticated users go to Role Selection (which leads to Login)
    return const RoleSelectionScreen();
  }
}
