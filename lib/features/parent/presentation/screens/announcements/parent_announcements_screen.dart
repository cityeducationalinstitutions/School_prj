import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/academic_models.dart';

class ParentAnnouncementsScreen extends StatelessWidget {
  const ParentAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final announcements = parentProvider.announcements;

    const Color primaryNavy = Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'School Circulars & Notices',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: announcements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No Announcements Right Now',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryNavy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Official school notices and circulars will be listed here.',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return _buildAnnouncementTile(announcement, primaryNavy);
              },
            ),
    );
  }

  Widget _buildAnnouncementTile(Announcement announcement, Color primaryNavy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE28743).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.campaign_rounded, color: Color(0xFFE28743), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    announcement.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Audience: Grade ${announcement.grade} ${announcement.section}',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                ),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(announcement.createdAt),
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
