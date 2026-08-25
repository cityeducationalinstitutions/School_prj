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
  String _selectedSection = 'All';

  final List<String> _classes = ['All', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _sections = ['All', 'A', 'B', 'C', 'S1', 'S2'];

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final String currentSchool = adminProvider.selectedSchoolId;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial & Fees',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF131742),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fee collections, dues & payment records',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddFeeStructureDialog(context, currentSchool),
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                label: const Text('Add Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE28743),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Total Stats Cards
          Row(
            children: [
              Expanded(child: _buildFeeCard('Total Revenue', '₹ 10L', Colors.blue, Icons.account_balance_wallet_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _buildFeeCard('Collected', '₹ 7.5L', Colors.green, Icons.check_circle_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _buildFeeCard('Pending', '₹ 2.5L', Colors.orange, Icons.hourglass_empty_rounded)),
            ],
          ),
          const SizedBox(height: 18),

          // Filters Card with Class & Section side by side
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742), size: 20),
                          items: _classes.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c == 'All' ? 'All Classes' : c,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedClass = val!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSection,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742), size: 20),
                          items: _sections.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s == 'All' ? 'All Sections' : 'Sec $s',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedSection = val!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Payment Records list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('fees').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No fee records found.', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                var allDocs = snapshot.data!.docs;
                var filteredRecords = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String grade = data['grade'] ?? data['classId'] ?? '';
                  final String section = data['section'] ?? '';

                  if (_selectedClass != 'All') {
                    if (grade.isNotEmpty && !grade.toLowerCase().contains(_selectedClass.replaceAll('Class ', '').toLowerCase()) && !grade.toLowerCase().contains(_selectedClass.toLowerCase())) {
                      return false;
                    }
                  }

                  if (_selectedSection != 'All') {
                    if (section.isNotEmpty && section.toLowerCase() != _selectedSection.toLowerCase()) {
                      return false;
                    }
                  }
                  return true;
                }).toList();

                if (filteredRecords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No fee records match the selected class & section.', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, listConstraints) {
                    if (listConstraints.maxWidth > 768) {
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade100),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFF131742).withOpacity(0.03)),
                            columns: const [
                              DataColumn(label: Text('Student ID')),
                              DataColumn(label: Text('Class & Sec')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Due Date')),
                            ],
                            rows: filteredRecords.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final double amount = (data['amount'] ?? 0).toDouble();
                              final bool isPaid = data['status'] == 'Paid' || data['status'] == 'clear' || (data['remainingBalance'] ?? 0) == 0;
                              final String gradeInfo = data['grade'] ?? data['classId'] ?? 'N/A';
                              final String secInfo = data['section'] != null ? ' - Sec ${data['section']}' : '';

                              return DataRow(
                                cells: [
                                  DataCell(Text(data['studentId'] ?? 'N/A', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataCell(Text('$gradeInfo$secInfo')),
                                  DataCell(Text('₹ $amount')),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
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
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: filteredRecords.length,
                        itemBuilder: (context, index) {
                          final data = filteredRecords[index].data() as Map<String, dynamic>;
                          final double amount = (data['amount'] ?? 0).toDouble();
                          final bool isPaid = data['status'] == 'Paid' || data['status'] == 'clear' || (data['remainingBalance'] ?? 0) == 0;
                          final String gradeInfo = data['grade'] ?? data['classId'] ?? '';
                          final String secInfo = data['section'] != null ? 'Sec ${data['section']}' : '';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
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
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                  child: Icon(
                                    isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                                    color: isPaid ? Colors.green : Colors.orange,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Student: ${data['studentId'] ?? 'N/A'}',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: const Color(0xFF131742),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          if (gradeInfo.isNotEmpty) ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF131742).withOpacity(0.06),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '$gradeInfo ${secInfo.isNotEmpty ? "• $secInfo" : ""}',
                                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                          ],
                                          Text(
                                            'Due: ${data['dueDate'] ?? 'N/A'}',
                                            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹ ${amount.toInt()}',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: const Color(0xFF131742),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isPaid ? 'Clear' : 'Pending',
                                        style: TextStyle(
                                          color: isPaid ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
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

  Widget _buildFeeCard(String title, String value, Color color, IconData icon) {
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
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
              ],
            ),
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
    String gradeVal = 'Class 1';
    String sectionVal = 'A';
    String statusVal = 'Pending';
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE28743).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFE28743), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add Fee Record',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                  Text(
                                    'Record tuition dues & invoices',
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // Form Inputs
                        _buildInputField(
                          controller: studentIdController,
                          label: 'Student UID / ID',
                          hint: 'Enter student user UID',
                          icon: Icons.badge_outlined,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Student ID required' : null,
                        ),
                        const SizedBox(height: 14),

                        // Class & Section Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildDropdownField(
                                label: 'Class',
                                icon: Icons.school_outlined,
                                value: gradeVal,
                                items: _classes.where((c) => c != 'All').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                onChanged: (val) => setDialogState(() => gradeVal = val!),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: _buildDropdownField(
                                label: 'Section',
                                icon: Icons.layers_outlined,
                                value: sectionVal,
                                items: _sections.where((s) => s != 'All').map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (val) => setDialogState(() => sectionVal = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: amountController,
                          label: 'Fee Amount (INR)',
                          hint: 'e.g. 25000',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Amount required';
                            if (double.tryParse(v) == null) return 'Enter valid numeric amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: dueDateController,
                          label: 'Due Date',
                          hint: 'YYYY-MM-DD',
                          icon: Icons.calendar_today_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Due date required' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildDropdownField(
                          label: 'School Assignment',
                          icon: Icons.business_outlined,
                          value: schoolVal,
                          items: const [
                            DropdownMenuItem(value: 'city_talent', child: Text('City Talent School')),
                            DropdownMenuItem(value: 'city_elite', child: Text('City Elite School')),
                            DropdownMenuItem(value: 'new_vision', child: Text('New Vision High School')),
                          ],
                          onChanged: (val) => setDialogState(() => schoolVal = val!),
                        ),
                        const SizedBox(height: 14),

                        _buildDropdownField(
                          label: 'Payment Status',
                          icon: Icons.payments_outlined,
                          value: statusVal,
                          items: const [
                            DropdownMenuItem(value: 'Paid', child: Text('Paid / Cleared')),
                            DropdownMenuItem(value: 'Pending', child: Text('Pending Payment')),
                          ],
                          onChanged: (val) => setDialogState(() => statusVal = val!),
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey.shade700,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isSaving ? null : () async {
                                  if (formKey.currentState!.validate()) {
                                    setDialogState(() => isSaving = true);
                                    try {
                                      final double parsedAmount = double.parse(amountController.text.trim());
                                      await _firestore.collection('fees').add({
                                        'studentId': studentIdController.text.trim(),
                                        'grade': gradeVal,
                                        'section': sectionVal,
                                        'amount': parsedAmount,
                                        'dueDate': dueDateController.text.trim(),
                                        'schoolId': schoolVal,
                                        'status': statusVal,
                                        'remainingBalance': statusVal == 'Paid' ? 0.0 : parsedAmount,
                                        'createdAt': FieldValue.serverTimestamp(),
                                      });
                                      if (mounted) Navigator.pop(dialogContext);
                                    } catch (e) {
                                      setDialogState(() => isSaving = false);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE28743),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Text('Save Record', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF131742)),
            filled: true,
            fillColor: const Color(0xFFF8F9FE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE28743), width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    final bool valueExists = items.any((item) => item.value == value);
    final String safeValue = valueExists ? value : (items.isNotEmpty ? items.first.value! : value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742), size: 20),
              items: items,
              onChanged: onChanged,
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF131742), fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
