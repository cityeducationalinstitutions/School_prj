import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceholderFeatureScreen extends StatelessWidget {
  final String title;
  const PlaceholderFeatureScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF131742),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE28743).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.construction_rounded, size: 64, color: Color(0xFFE28743)),
            ),
            const SizedBox(height: 24),
            Text(
              'Feature Coming Soon!',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
            ),
            const SizedBox(height: 8),
            Text(
              'We are working hard to build this feature for you.',
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
