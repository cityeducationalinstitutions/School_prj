import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/grade_models.dart';
import 'package:management/models/school_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class GradeBookPdfService {
  static Future<pw.Document> _buildDocument({
    required SchoolModel school,
    required ClassModel clazz,
    required String subject,
    required String examType,
    required List<StudentModel> students,
    required List<MarksModel> marks,
  }) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(school.name.toUpperCase(), style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('EXAMINATION REPORT SHEET', style: pw.TextStyle(fontSize: 14)),
                  pw.Divider(),
                  pw.SizedBox(height: 8),
                ],
              ),
            ),

            // Class Info Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Class: ${clazz.name} - ${clazz.section}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Subject: $subject'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Exam: $examType', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _cell('S.No', isHeader: true),
                    _cell('Roll No', isHeader: true),
                    _cell('Student Name', isHeader: true),
                    _cell('Marks', isHeader: true),
                    _cell('Result', isHeader: true),
                  ],
                ),
                // Table Rows
                for (int i = 0; i < students.length; i++)
                  (() {
                    final student = students[i];
                    final mark = marks.firstWhere(
                      (m) => m.studentId == student.id && m.examType == examType,
                      orElse: () => MarksModel(id: '', studentId: student.id, classId: student.classId, subject: subject, examType: examType, marksObtained: -1, totalMarks: 100),
                    );
                    final marksText = mark.marksObtained >= 0 ? mark.marksObtained.toStringAsFixed(0) : 'N/A';
                    final resultText = mark.marksObtained >= 35 ? 'PASS' : (mark.marksObtained >= 0 ? 'FAIL' : 'PENDING');

                    return pw.TableRow(
                      children: [
                        _cell('${i + 1}'),
                        _cell(student.rollNo),
                        _cell(student.name),
                        _cell(marksText),
                        _cell(resultText, color: resultText == 'PASS' ? PdfColors.green : (resultText == 'FAIL' ? PdfColors.red : PdfColors.black)),
                      ],
                    );
                  })(),
              ],
            ),

            pw.SizedBox(height: 40),

            // Footer / Signatures
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Container(width: 120, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 4),
                    pw.Text('Teacher Signature'),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Container(width: 120, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 4),
                    pw.Text('Principal Signature'),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );
    
    return pdf;
  }

  static Future<void> generateMarksSheet({
    required SchoolModel school,
    required ClassModel clazz,
    required String subject,
    required String examType,
    required List<StudentModel> students,
    required List<MarksModel> marks,
  }) async {
    final pdf = await _buildDocument(
      school: school,
      clazz: clazz,
      subject: subject,
      examType: examType,
      students: students,
      marks: marks,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${school.name}_${clazz.name}_$subject.pdf',
    );
  }

  static Future<void> downloadMarksSheet({
    required SchoolModel school,
    required ClassModel clazz,
    required String subject,
    required String examType,
    required List<StudentModel> students,
    required List<MarksModel> marks,
  }) async {
    final pdf = await _buildDocument(
      school: school,
      clazz: clazz,
      subject: subject,
      examType: examType,
      students: students,
      marks: marks,
    );
    
    final bytes = await pdf.save();
    final fileName = '${school.name.replaceAll(' ', '_')}_${clazz.name.replaceAll(' ', '_')}_$subject.pdf';

    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Marks Sheet',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: bytes,
      );

      if (outputFile != null && !Platform.isIOS && !Platform.isAndroid) {
        final file = File(outputFile);
        await file.writeAsBytes(bytes);
      }
      
      if (outputFile == null && (Platform.isAndroid || Platform.isIOS)) {
        await Printing.sharePdf(bytes: bytes, filename: fileName);
      }
    } catch (e) {
      await Printing.sharePdf(bytes: bytes, filename: fileName);
    }
  }

  static pw.Widget _cell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
        ),
      ),
    );
  }
}
