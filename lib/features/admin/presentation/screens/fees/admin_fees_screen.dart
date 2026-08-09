import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';

class AdminFeesScreen extends StatefulWidget {
  const AdminFeesScreen({super.key});

  @override
  State<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends State<AdminFeesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedClass = 'All';

  final List<String> _classes = ['All', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];

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
                'Financial & Fee Administration',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddFeeStructureDialog(context, currentSchool),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Fee Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE28743),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Stats Cards
          Row(
            children: [
              Expanded(child: _buildFeeCard('Total Revenue', '₹ 10,00,000', Colors.blue, Icons.account_balance_wallet)),
              const SizedBox(width: 16),
              Expanded(child: _buildFeeCard('Collected Fees', '₹ 7,50,000', Colors.green, Icons.check_circle)),
              const SizedBox(width: 16),
              Expanded(child: _buildFeeCard('Pending Dues', '₹ 2,50,000', Colors.orange, Icons.hourglass_empty)),
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
                  const Text('Filter by Class: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedClass,
                    items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedClass = val!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment Records list
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('fees').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No fee records found.'));
                  }

                  var feeRecords = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Student ID')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Due Date')),
                      ],
                      rows: feeRecords.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final double amount = (data['amount'] ?? 0).toDouble();
                        final bool isPaid = data['status'] == 'Paid' || data['status'] == 'clear' || (data['remainingBalance'] ?? 0) == 0;
                        return DataRow(
                          cells: [
                            DataCell(Text(data['studentId'] ?? 'N/A', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                            DataCell(Text('₹ $amount')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isPaid ? 'Clear' : 'Pending',
                                  style: TextStyle(color: isPaid ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(Text(data['dueDate'] != null ? (data['dueDate'] as String) : 'N/A')),
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

  Widget _buildFeeCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddFeeStructureDialog(BuildContext context, String initialSchool) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final studentIdController = TextEditingController();
    final dueDateController = TextEditingController(text: '2026-10-31');
    String schoolVal = initialSchool == 'all' ? 'city_talent' : initialSchool;
    String statusVal = 'Pending';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Fee Record'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID / User ID'),
                    validator: (v) => v!.isEmpty ? 'Student ID required' : null,
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Fee Amount (INR)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Amount required' : null,
                  ),
                  TextFormField(
                    controller: dueDateController,
                    decoration: const InputDecoration(labelText: 'Due Date'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: schoolVal,
                    decoration: const InputDecoration(labelText: 'School'),
                    items: const [
                      DropdownMenuItem(value: 'city_talent', child: Text('City Talent School')),
                      DropdownMenuItem(value: 'city_elite', child: Text('City Elite School')),
                      DropdownMenuItem(value: 'new_vision', child: Text('New Vision High School')),
                    ],
                    onChanged: (val) => schoolVal = val!,
                  ),
                  DropdownButtonFormField<String>(
                    value: statusVal,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    ],
                    onChanged: (val) => statusVal = val!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _firestore.collection('fees').add({
                    'studentId': studentIdController.text.trim(),
                    'amount': double.parse(amountController.text.trim()),
                    'dueDate': dueDateController.text.trim(),
                    'schoolId': schoolVal,
                    'status': statusVal,
                    'remainingBalance': statusVal == 'Paid' ? 0.0 : double.parse(amountController.text.trim()),
                  });
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
