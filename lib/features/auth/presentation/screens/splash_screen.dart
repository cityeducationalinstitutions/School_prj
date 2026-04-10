import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color schoolOrange = Color(0xFFE28743);
    const Color darkNavy = Color(0xFF131742);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with subtle circular background
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: schoolOrange.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  'assets/images/school_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Primary Telugu Text in School Orange
            Text(
              'శ్రమతో సర్వం సాధ్యం',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: schoolOrange,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle text in Navy to provide contrast
            Text(
              'City Educational Institutions',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: darkNavy.withOpacity(0.6),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 80),
            // Loading indicator (Pulse)
            SpinKitPulse(
              color: Colors.grey.withOpacity(0.2),
              size: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
