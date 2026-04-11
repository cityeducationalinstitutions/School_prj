import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/academic_models.dart';

class StudentAnnouncementsScreen extends StatelessWidget {
  const StudentAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: schoolBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: studentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentProvider.announcements.isEmpty
              ? _EmptyAnnouncementsView()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: studentProvider.announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = studentProvider.announcements[index];
                    return _AnnouncementCard(
                      title: announcement.title,
                      content: announcement.message,
                      author: 'Official', // senderName not in refined model
                      date: announcement.createdAt,
                      category: 'General', // In standardized model, senderType could be used
                    );
                  },
                ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final DateTime date;
  final String category;

  const _AnnouncementCard({
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: schoolBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: schoolBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: schoolOrange.withOpacity(0.1),
                      child: Text(
                        author.isNotEmpty ? author[0].toUpperCase() : 'A',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: schoolOrange),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Posted by $author',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAnnouncementsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_rounded, size: 64, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            'No announcements yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


