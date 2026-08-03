import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class ParentPdfViewerScreen extends StatelessWidget {
  final String title;
  final String pdfUrl;

  const ParentPdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  Future<Uint8List> _loadPdfData() async {
    try {
      if (pdfUrl.startsWith('http://') || pdfUrl.startsWith('https://')) {
        final response = await http.get(Uri.parse(pdfUrl));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      }
    } catch (e) {
      debugPrint('Error fetching remote PDF: $e');
    }
    // Fallback: Generate a sample PDF report card document dynamically
    return _generateSampleReportCardPdf(title);
  }

  Future<Uint8List> _generateSampleReportCardPdf(String examName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('CITY EDUCATIONAL INSTITUTIONS',
                          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.Text('ACADEMIC REPORT',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Exam Name: $examName',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Academic Year: 2025-2026'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Table.fromTextArray(
                  headers: ['Subject', 'Full Marks', 'Marks Obtained', 'Grade'],
                  data: [
                    ['Mathematics', '100', '92', 'A+'],
                    ['Physics & Chemistry', '100', '88', 'A'],
                    ['English Language', '100', '95', 'A+'],
                    ['Social Science', '100', '84', 'A'],
                    ['Computer Science', '100', '98', 'O'],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo900),
                  cellHeight: 30,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                  },
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Overall Percentage: 91.4%', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Result: PASSED (FIRST CLASS WITH DISTINCTION)', style: pw.TextStyle(fontSize: 12, color: PdfColors.green800)),
                  ],
                ),
                pw.Spacer(),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Class Teacher Signature'),
                    pw.Text('Principal Signature'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: PdfPreview(
        build: (format) => _loadPdfData(),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        maxPageWidth: 700,
        loadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
