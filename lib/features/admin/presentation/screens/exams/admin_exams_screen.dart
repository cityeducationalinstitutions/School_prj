import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';

class AdminExamsScreen extends StatefulWidget {
  const AdminExamsScreen({super.key});

  @override
  State<AdminExamsScreen> createState() => _AdminExamsScreenState();
}

class _AdminExamsScreenState extends State<AdminExamsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedGrade = 'Class 10';
  String _selectedExam = 'Quarterly';

  final List<String> _grades = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _exams = ['Quarterly', 'Half-Yearly', 'Annual', 'Final', 'Unit Test 1', 'Unit Test 2'];

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gradebook Management',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Class-wise & subject-wise performance diagnostics',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters Card
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGrade,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (val) => setState(() => _selectedGrade = val!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedExam,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: _exams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _selectedExam = val!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Summary Stats Cards
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('marks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
              }

              double overallAverage = 0.0;
              double highestMarks = 0.0;
              double overallPassingRate = 0.0;

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<Map<String, dynamic>> filteredMarks = [];
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String exam = data['examName'] ?? data['examType'] ?? 'N/A';
                  if (exam.toLowerCase() == _selectedExam.toLowerCase()) {
                    filteredMarks.add(data);
                  }
                }

                if (filteredMarks.isNotEmpty) {
                  double totalObtained = 0;
                  double totalMax = 0;
                  int passed = 0;

                  for (var m in filteredMarks) {
                    final double score = (m['marks'] ?? m['marksObtained'] ?? 0).toDouble();
                    final double maxScore = (m['totalMarks'] ?? 100).toDouble();

                    totalObtained += score;
                    totalMax += maxScore;

                    if (score > highestMarks) {
                      highestMarks = score;
                    }

                    double pct = maxScore > 0 ? (score / maxScore) * 100 : 0;
                    if (pct >= 35) {
                      passed++;
                    }
                  }

                  overallAverage = totalMax > 0 ? (totalObtained / totalMax) * 100 : 0;
                  overallPassingRate = (passed / filteredMarks.length) * 100;
                }
              }

              return Row(
                children: [
                  Expanded(child: _buildExamStatCard('Class Average', '${overallAverage.toStringAsFixed(1)}%', Colors.blue, Icons.analytics_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildExamStatCard('Highest Mark', '${highestMarks.toInt()} / 100', Colors.green, Icons.emoji_events_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildExamStatCard('Passing Rate', '${overallPassingRate.toStringAsFixed(1)}%', Colors.purple, Icons.check_circle_rounded)),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Gradebook List / Table
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('marks').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No academic marks found.'));
                }

                // Group marks by (subject, exam)
                Map<String, List<Map<String, dynamic>>> groupedData = {};

                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String subject = data['subject'] ?? 'N/A';
                  final String exam = data['examName'] ?? data['examType'] ?? 'N/A';

                  if (exam.toLowerCase() != _selectedExam.toLowerCase()) {
                    continue;
                  }

                  final String key = '$subject|$exam';
                  if (!groupedData.containsKey(key)) {
                    groupedData[key] = [];
                  }
                  groupedData[key]!.add(data);
                }

                if (groupedData.isEmpty) {
                  return const Center(child: Text('No marks matches selected filters.'));
                }

                List<_SubjectPerformance> performanceList = [];

                groupedData.forEach((key, records) {
                  final parts = key.split('|');
                  final String subject = parts[0];
                  final String exam = parts[1];

                  double totalObtained = 0;
                  double totalMax = 0;
                  double highest = 0;
                  int passedCount = 0;

                  for (var r in records) {
                    final double score = (r['marks'] ?? r['marksObtained'] ?? 0).toDouble();
                    final double maxMarks = (r['totalMarks'] ?? 100).toDouble();

                    totalObtained += score;
                    totalMax += maxMarks;

                    if (score > highest) {
                      highest = score;
                    }

                    double pct = maxMarks > 0 ? (score / maxMarks) * 100 : 0;
                    if (pct >= 35) {
                      passedCount++;
                    }
                  }

                  double avgPct = totalMax > 0 ? (totalObtained / totalMax) * 100 : 0;
                  double passRate = records.isNotEmpty ? (passedCount / records.length) * 100 : 0;

                  performanceList.add(_SubjectPerformance(
                    subject: subject,
                    exam: exam,
                    avgPercentage: avgPct,
                    highestScore: highest,
                    passRate: passRate,
                  ));
                });

                return LayoutBuilder(
                  builder: (context, listConstraints) {
                    if (listConstraints.maxWidth > 768) {
                      // Desktop view (DataTable)
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade100),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(const Color(0xFF131742).withOpacity(0.03)),
                              columns: const [
                                DataColumn(label: Text('Subject')),
                                DataColumn(label: Text('Exam')),
                                DataColumn(label: Text('Avg Marks')),
                                DataColumn(label: Text('Highest Marks')),
                                DataColumn(label: Text('Pass Rate')),
                              ],
                              rows: performanceList.map((perf) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(perf.subject, style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                    DataCell(Text(perf.exam)),
                                    DataCell(Text('${perf.avgPercentage.toStringAsFixed(1)}%')),
                                    DataCell(Text('${perf.highestScore.toInt()} / 100')),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: perf.passRate >= 75 ? Colors.green.withOpacity(0.1) : (perf.passRate >= 50 ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${perf.passRate.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            color: perf.passRate >= 75 ? Colors.green : (perf.passRate >= 50 ? Colors.orange : Colors.red),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Mobile view (Card List)
                      return ListView.builder(
                        itemCount: performanceList.length,
                        itemBuilder: (context, index) {
                          return _buildSubjectMobileCard(performanceList[index]);
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectMobileCard(_SubjectPerformance perf) {
    final IconData icon = _getSubjectIcon(perf.subject);
    final Color passColor = perf.passRate >= 75 ? Colors.green : (perf.passRate >= 50 ? Colors.orange : Colors.red);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF131742).withOpacity(0.06),
                child: Icon(icon, color: const Color(0xFF131742), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      perf.subject,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF131742),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Exam: ${perf.exam}',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Avg: ${perf.avgPercentage.toStringAsFixed(1)}%',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF131742)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Highest: ${perf.highestScore.toInt()}/100',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Passing rate progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: perf.passRate / 100,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(passColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${perf.passRate.toStringAsFixed(0)}% Pass',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: passColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    final name = subject.toLowerCase();
    if (name.contains('math')) return Icons.calculate_rounded;
    if (name.contains('science') || name.contains('physics') || name.contains('chemistry') || name.contains('biology')) {
      return Icons.science_rounded;
    }
    if (name.contains('english') || name.contains('telugu') || name.contains('hindi')) {
      return Icons.translate_rounded;
    }
    if (name.contains('social') || name.contains('history') || name.contains('geography')) {
      return Icons.public_rounded;
    }
    return Icons.menu_book_rounded;
  }
}

class _SubjectPerformance {
  final String subject;
  final String exam;
  final double avgPercentage;
  final double highestScore;
  final double passRate;

  _SubjectPerformance({
    required this.subject,
    required this.exam,
    required this.avgPercentage,
    required this.highestScore,
    required this.passRate,
  });
}
