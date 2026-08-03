import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/features/parent/presentation/screens/reportcards/parent_pdf_viewer_screen.dart';
import 'package:management/models/report_card_model.dart';

class ParentReportCardsScreen extends StatelessWidget {
  const ParentReportCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final reportCards = parentProvider.reportCards;

    const Color primaryNavy = Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Academic Report Cards',
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
      body: RefreshIndicator(
        onRefresh: () => parentProvider.fetchReportCards(),
        child: reportCards.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Icon(Icons.description_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No Report Cards Published Yet',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryNavy),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Official term evaluation cards will appear here.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: reportCards.length,
                itemBuilder: (context, index) {
                  final card = reportCards[index];
                  return _buildReportCardTile(context, card, primaryNavy);
                },
              ),
      ),
    );
  }

  Widget _buildReportCardTile(BuildContext context, ReportCard card, Color primaryNavy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131742).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFFD32F2F),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.examName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 13, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Text(
                            'Published: ${DateFormat('dd MMMM yyyy').format(card.createdAt)}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentPdfViewerScreen(
                            title: card.examName,
                            pdfUrl: card.fileUrl,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                    label: const Text('View PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryNavy,
                      side: BorderSide(color: primaryNavy.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentPdfViewerScreen(
                            title: '${card.examName} - Save',
                            pdfUrl: card.fileUrl,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE28743),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
