import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:management/models/academic_models.dart';

class DoubtDetailScreen extends StatelessWidget {
  final AcademicDoubt doubt;

  const DoubtDetailScreen({super.key, required this.doubt});

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Doubt Details', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: schoolBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildBadge(doubt.subject, schoolOrange.withOpacity(0.1), schoolOrange),
                const SizedBox(width: 8),
                _buildBadge(
                  doubt.status.toUpperCase(), 
                  _getStatusColor(doubt.status).withOpacity(0.1), 
                  _getStatusColor(doubt.status)
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SelectionArea(
              child: Text(
                doubt.title,
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: schoolBlue),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Asked on ${DateFormat('MMMM dd, yyyy').format(doubt.createdAt)}',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 32),

            const _SectionHeader('My Question'),
            const SizedBox(height: 12),
            SelectionArea(
              child: Text(
                doubt.description,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade800, height: 1.6),
              ),
            ),
            const SizedBox(height: 24),

            if (doubt.attachmentUrl != null) ...[
              const _SectionHeader('Attachment'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showFullImage(context, doubt.attachmentUrl!),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: doubt.attachmentUrl!,
                    placeholder: (context, url) => Container(height: 200, color: Colors.grey.shade100, child: const Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Divider(height: 64),

            const _SectionHeader('Teacher\'s Response'),
            const SizedBox(height: 16),
            if (doubt.answer == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty_rounded, color: Colors.blue.shade300, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Your doubt is pending review.',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A teacher will reply soon.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.blue.shade800.withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.green.shade600, radius: 12, child: const Icon(Icons.check, size: 14, color: Colors.white)),
                        const SizedBox(width: 8),
                        Text('Response', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SelectionArea(
                      child: Text(
                        doubt.answer!,
                        style: GoogleFonts.inter(fontSize: 16, color: Colors.green.shade900, height: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'resolved': return Colors.green;
      case 'in_progress': return Colors.orange;
      default: return Colors.blue;
    }
  }

  void _showFullImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0),
          body: Center(child: InteractiveViewer(child: CachedNetworkImage(imageUrl: url))),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.grey.shade400, letterSpacing: 1.5),
    );
  }
}
