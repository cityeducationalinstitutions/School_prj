import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/models/user_model.dart';

class AdminStudentProfileScreen extends StatefulWidget {
  final UserModel student;
  const AdminStudentProfileScreen({super.key, required this.student});

  @override
  State<AdminStudentProfileScreen> createState() => _AdminStudentProfileScreenState();
}

class _AdminStudentProfileScreenState extends State<AdminStudentProfileScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  Map<String, dynamic>? _parentData;
  bool _isLoadingParent = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchParentDetails();
  }

  Future<void> _fetchParentDetails() async {
    try {
      // Query parent users who have this student in their childrenIds
      final q1 = await _firestore
          .collection('users')
          .where('roles', arrayContains: 'parent')
          .where('childrenIds', arrayContains: widget.student.uid)
          .get();

      if (q1.docs.isNotEmpty) {
        setState(() {
          _parentData = q1.docs.first.data();
          _isLoadingParent = false;
        });
        return;
      }

      // Fallback: Query parent users who have this student as childStudentId
      final q2 = await _firestore
          .collection('users')
          .where('roles', arrayContains: 'parent')
          .where('childStudentId', isEqualTo: widget.student.uid)
          .get();

      if (q2.docs.isNotEmpty) {
        setState(() {
          _parentData = q2.docs.first.data();
          _isLoadingParent = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Error fetching parent: $e');
    }
    setState(() => _isLoadingParent = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String initial = widget.student.name.isNotEmpty ? widget.student.name[0].toUpperCase() : 'S';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF131742),
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF131742),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: Text(
                    initial,
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _capitalize(widget.student.name),
                        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'School: ${_formatSchool(widget.student.schoolId)}',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE28743),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.student.grade ?? 'N/A',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          if (widget.student.section != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Section: ${widget.student.section}',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TabBar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFFE28743),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFE28743),
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.person_outline_rounded)),
              Tab(text: 'Attendance', icon: Icon(Icons.calendar_today_rounded)),
              Tab(text: 'Marks', icon: Icon(Icons.grade_rounded)),
              Tab(text: 'Fees', icon: Icon(Icons.payment_rounded)),
              Tab(text: 'Remarks', icon: Icon(Icons.assignment_rounded)),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAttendanceTab(),
                _buildMarksTab(),
                _buildFeesTab(),
                _buildRemarksTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Dynamic Performance Card
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('marks').where('studentId', isEqualTo: widget.student.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildPerformanceCard(0, 'No Marks Uploaded', 'N/A');
              }
              
              double totalMarksObtained = 0;
              double totalMaxMarks = 0;
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final double marks = (data['marks'] ?? data['marksObtained'] ?? 0).toDouble();
                final double maxMarks = (data['totalMarks'] ?? 100).toDouble();
                totalMarksObtained += marks;
                totalMaxMarks += maxMarks;
              }
              
              double overallPct = totalMaxMarks > 0 ? (totalMarksObtained / totalMaxMarks) * 100 : 0;
              
              String status = 'Needs Improvement';
              String grade = 'D';
              if (overallPct >= 85) {
                status = 'Outstanding';
                grade = 'A';
              } else if (overallPct >= 70) {
                status = 'Excellent';
                grade = 'B';
              } else if (overallPct >= 50) {
                status = 'Average';
                grade = 'C';
              }
              
              return _buildPerformanceCard(overallPct, status, grade);
            },
          ),
          const SizedBox(height: 16),

          // Personal Details Card
          _buildDetailCard(
            title: 'Personal Information',
            icon: Icons.person_rounded,
            children: [
              _buildInfoRow('Full Name', _capitalize(widget.student.name)),
              _buildInfoRow('Email Address', widget.student.email),
              _buildInfoRow('Student UID', widget.student.uid),
            ],
          ),
          const SizedBox(height: 16),

          // Parent Information
          _isLoadingParent
              ? const Center(child: CircularProgressIndicator())
              : _buildDetailCard(
                  title: 'Parent Information',
                  icon: Icons.family_restroom_rounded,
                  children: _parentData == null
                      ? [const Text('No linked parent data found.')]
                      : [
                          _buildInfoRow('Parent Name', _parentData!['name'] ?? 'N/A'),
                          _buildInfoRow('Parent Email', _parentData!['email'] ?? 'N/A'),
                          _buildInfoRow('Phone Number', _parentData!['phone'] ?? _parentData!['phoneNumber'] ?? 'N/A'),
                        ],
                ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: widget.student.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No attendance logs recorded.'));
        }

        final logs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final data = logs[index].data() as Map<String, dynamic>;
            final bool isPresent = data['status'] == 'Present' || data['present'] == true;
            final date = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['subject'] ?? 'Daily Attendance',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF131742)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isPresent ? 'Present' : 'Absent',
                      style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMarksTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('marks')
          .where('studentId', isEqualTo: widget.student.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No academic marks uploaded.'));
        }

        final marksList = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: marksList.length,
          itemBuilder: (context, index) {
            final data = marksList[index].data() as Map<String, dynamic>;
            final double marks = (data['marks'] ?? data['marksObtained'] ?? 0).toDouble();
            final double total = (data['totalMarks'] ?? 100).toDouble();
            final double pct = total > 0 ? (marks / total) * 100 : 0;
            final Color color = pct >= 75 ? Colors.green : (pct >= 50 ? Colors.orange : Colors.red);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['subject'] ?? 'Subject',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF131742)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['examName'] ?? data['examType'] ?? 'Exam',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${marks.toInt()} / ${total.toInt()}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pct.toStringAsFixed(1)}%',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('fees')
          .where('studentId', isEqualTo: widget.student.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No fee records created for this student.'));
        }

        final feeDocs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: feeDocs.length,
          itemBuilder: (context, index) {
            final data = feeDocs[index].data() as Map<String, dynamic>;
            final double amount = (data['amount'] ?? 0).toDouble();
            final bool isPaid = data['status'] == 'Paid' || data['status'] == 'clear' || (data['remainingBalance'] ?? 0) == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School Fees Record',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF131742)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due Date: ${data['dueDate'] ?? 'N/A'}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹ ${amount.toInt()}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF131742)),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPaid ? 'Clear' : 'Pending',
                          style: TextStyle(color: isPaid ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRemarksTab() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('diary')
                .where('classId', isEqualTo: widget.student.classId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No remarks or assignments recorded.'));
              }

              final remarks = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: remarks.length,
                itemBuilder: (context, index) {
                  final data = remarks[index].data() as Map<String, dynamic>;
                  final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['subject'] ?? 'Subject',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFFE28743)),
                            ),
                            Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Topic: ${data['topic'] ?? 'N/A'}',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF131742)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['homework'] ?? 'No remark text.',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Quick Add Diary Entry Form for Admin
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddDiaryDialog(context),
                  icon: const Icon(Icons.add_comment_rounded),
                  label: const Text('Add Teacher Remark / Homework'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF131742),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF131742), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500)),
          Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map((str) => str.isNotEmpty ? str[0].toUpperCase() + str.substring(1).toLowerCase() : '').join(' ');
  }

  String _formatSchool(String? id) {
    if (id == 'city_talent') return 'City Talent School';
    if (id == 'city_elite') return 'City Elite School';
    if (id == 'new_vision') return 'New Vision High School';
    return id ?? 'N/A';
  }

  void _showAddDiaryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final topicController = TextEditingController();
    final homeworkController = TextEditingController();
    final subjectController = TextEditingController(text: 'General');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Remark / Homework'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Subject / Category'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: topicController,
                  decoration: const InputDecoration(labelText: 'Topic'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: homeworkController,
                  decoration: const InputDecoration(labelText: 'Remark Details / Homework Description'),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _firestore.collection('diary').add({
                    'classId': widget.student.classId ?? '',
                    'grade': widget.student.grade ?? '',
                    'section': widget.student.section ?? '',
                    'subject': subjectController.text.trim(),
                    'topic': topicController.text.trim(),
                    'homework': homeworkController.text.trim(),
                    'date': Timestamp.now(),
                  });
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPerformanceCard(double percentage, String status, String grade) {
    Color gradeColor = Colors.red;
    if (grade == 'A') gradeColor = Colors.green;
    if (grade == 'B') gradeColor = Colors.blue;
    if (grade == 'C') gradeColor = Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color(0xFF131742), size: 20),
              const SizedBox(width: 10),
              Text(
                'Academic Performance Summary',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERALL AGGREGATE',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      percentage > 0 ? '${percentage.toStringAsFixed(1)}%' : 'N/A',
                      style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: gradeColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF131742).withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF131742).withOpacity(0.1), width: 2),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GRADE',
                      style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      grade,
                      style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
