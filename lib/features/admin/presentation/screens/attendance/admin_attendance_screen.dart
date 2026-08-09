import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedClass = 'Class 10';
  String _selectedSection = 'A';
  DateTime _selectedDate = DateTime.now();

  final List<String> _classes = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _sections = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final String currentSchool = adminProvider.selectedSchoolId;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Logs',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                ),
              ),
              Text(
                'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Overview
          Row(
            children: [
              Expanded(child: _buildAttendanceStat('Present', '92%', Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildAttendanceStat('Absent', '5%', Colors.red)),
              const SizedBox(width: 16),
              Expanded(child: _buildAttendanceStat('On Leave', '3%', Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),

          // Filters Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedClass,
                    items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedClass = val!),
                  ),
                  const SizedBox(width: 24),
                  DropdownButton<String>(
                    value: _selectedSection,
                    items: _sections.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => _selectedSection = val!),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2027),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Change Date'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Attendance Log Table
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('attendance').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No attendance logs registered for this query.'));
                  }

                  var logs = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Student ID')),
                        DataColumn(label: Text('Subject/Session')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Timestamp')),
                      ],
                      rows: logs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final bool isPresent = data['status'] == 'Present' || data['present'] == true;
                        final String statusText = isPresent ? 'Present' : 'Absent';
                        final timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

                        return DataRow(
                          cells: [
                            DataCell(Text(data['studentId'] ?? 'N/A', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                            DataCell(Text(data['subject'] ?? 'Daily Attendance')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(Text('${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}')),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
