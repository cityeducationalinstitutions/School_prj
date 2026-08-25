import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';
import 'package:management/models/user_model.dart';
import 'package:management/features/admin/presentation/screens/students/admin_student_profile_screen.dart';

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({super.key});

  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGrade = 'All';
  String _selectedSection = 'All';

  final List<String> _grades = ['All', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _sections = ['All', 'A', 'B', 'C'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                      'Student Directory',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF131742),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage enrollment & credentials',
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
                onPressed: () => _showAddStudentDialog(context, currentSchool),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE28743),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Filters & Search Card
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Full Width Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search student by name or email...',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF131742), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8F9FE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGrade,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742)),
                              items: _grades.map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(
                                  g == 'All' ? 'All Classes' : g,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              )).toList(),
                              onChanged: (val) => setState(() => _selectedGrade = val!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
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
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742)),
                              items: _sections.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s == 'All' ? 'All Sections' : 'Section $s',
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Students List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').where('roles', arrayContains: 'student').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No students found', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                List<UserModel> students = snapshot.data!.docs.map((doc) {
                  return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                // Apply school filter
                if (currentSchool != 'all') {
                  students = students.where((s) => s.schoolId == currentSchool).toList();
                }

                // Apply Search & Grade / Section filters
                if (_searchQuery.isNotEmpty) {
                  students = students.where((s) =>
                    s.name.toLowerCase().contains(_searchQuery) ||
                    s.email.toLowerCase().contains(_searchQuery)
                  ).toList();
                }
                if (_selectedGrade != 'All') {
                  students = students.where((s) => s.grade == _selectedGrade).toList();
                }
                if (_selectedSection != 'All') {
                  students = students.where((s) => s.section == _selectedSection).toList();
                }

                if (students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No students match the search criteria.', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, listConstraints) {
                    if (listConstraints.maxWidth > 768) {
                      // Desktop DataTable view
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
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('School')),
                              DataColumn(label: Text('Class')),
                              DataColumn(label: Text('Section')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: students.map((s) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdminStudentProfileScreen(student: s),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        _capitalize(s.name),
                                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFFE28743)),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(_formatSchool(s.schoolId))),
                                  DataCell(Text(s.grade ?? 'N/A')),
                                  DataCell(Text(s.section ?? 'N/A')),
                                  DataCell(Text(s.email)),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                      onPressed: () => _confirmDeleteStudent(context, s.uid),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      // Mobile Card list view
                      return ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final s = students[index];
                          return _buildStudentMobileCard(s);
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

  Widget _buildStudentMobileCard(UserModel s) {
    String initial = s.name.isNotEmpty ? s.name[0].toUpperCase() : 'S';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminStudentProfileScreen(student: s),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF131742).withOpacity(0.08),
              child: Text(
                initial,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalize(s.name),
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF131742),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.business_rounded, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatSchool(s.schoolId),
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE28743).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s.grade ?? 'N/A',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE28743),
                          ),
                        ),
                      ),
                      if (s.section != null && s.section != 'N/A') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF131742).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Sec ${s.section}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF131742),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              onPressed: () => _confirmDeleteStudent(context, s.uid),
            ),
          ],
        ),
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

  void _showAddStudentDialog(BuildContext context, String initialSchool) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final rollNoController = TextEditingController(text: '01');
    final feeAmountController = TextEditingController(text: '35000');
    final parentNameController = TextEditingController();
    final parentPhoneController = TextEditingController();
    String schoolVal = initialSchool == 'all' ? 'city_talent' : initialSchool;
    String gradeVal = 'Class 1';
    String sectionVal = 'A';
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
                        // Dialog Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE28743).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFFE28743), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Student',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                  Text(
                                    'Student credentials, class & parent details',
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
                          controller: nameController,
                          label: 'Student Full Name',
                          hint: 'Enter student full name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter student name' : null,
                        ),
                        const SizedBox(height: 14),

                        // Roll Number & Email in Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildInputField(
                                controller: rollNoController,
                                label: 'Roll No',
                                hint: 'e.g. 01, 15',
                                icon: Icons.tag_rounded,
                                keyboardType: TextInputType.number,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: _buildInputField(
                                controller: emailController,
                                label: 'Student Email',
                                hint: 'student@cityschool.edu',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Please enter email';
                                  if (!v.contains('@')) return 'Enter valid email';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: passwordController,
                          label: 'Temporary Password',
                          hint: 'Minimum 6 characters',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                        ),
                        const SizedBox(height: 14),

                        // School dropdown
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

                        // Grade & Section in a Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildDropdownField(
                                label: 'Class',
                                icon: Icons.school_outlined,
                                value: gradeVal,
                                items: _grades.where((g) => g != 'All').map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
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

                        // Decided Annual Tuition Fee
                        _buildInputField(
                          controller: feeAmountController,
                          label: 'Decided Annual Fee (INR)',
                          hint: 'e.g. 35000',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter decided fee';
                            if (double.tryParse(v) == null) return 'Enter a valid numeric amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Parent / Guardian Section
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FE),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.family_restroom_rounded, size: 18, color: Color(0xFFE28743)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Parent / Guardian Details',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInputField(
                                controller: parentNameController,
                                label: 'Parent Full Name',
                                hint: 'e.g. Ramesh Kumar',
                                icon: Icons.person_rounded,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Parent name required' : null,
                              ),
                              const SizedBox(height: 12),
                              _buildInputField(
                                controller: parentPhoneController,
                                label: 'Parent Mobile Number',
                                hint: '+91 98765 43210',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Parent mobile required' : null,
                              ),
                            ],
                          ),
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
                                      final userRef = _firestore.collection('users').doc();
                                      final String formattedRoll = rollNoController.text.trim().padLeft(2, '0');
                                      String cleanGrade = gradeVal.replaceAll(RegExp(r'[^0-9]'), '');
                                      String formattedStudentId = '$cleanGrade$sectionVal$formattedRoll';
                                      final double parsedFee = double.tryParse(feeAmountController.text.trim()) ?? 35000.0;
                                      final String parentName = parentNameController.text.trim();
                                      final String parentPhone = parentPhoneController.text.trim();

                                      // 1. Save student profile
                                      await userRef.set({
                                        'name': nameController.text.trim(),
                                        'email': emailController.text.trim(),
                                        'roles': ['student'],
                                        'schoolId': schoolVal,
                                        'grade': gradeVal,
                                        'section': sectionVal,
                                        'rollNo': formattedRoll,
                                        'studentId': formattedStudentId,
                                        'decidedFee': parsedFee,
                                        'parentName': parentName,
                                        'parentPhone': parentPhone,
                                        'createdAt': FieldValue.serverTimestamp(),
                                      });

                                      // 2. Initialize student's fee record
                                      await _firestore.collection('fees').add({
                                        'studentId': userRef.id,
                                        'studentUniqueId': formattedStudentId,
                                        'studentName': nameController.text.trim(),
                                        'grade': gradeVal,
                                        'section': sectionVal,
                                        'schoolId': schoolVal,
                                        'amount': parsedFee,
                                        'remainingBalance': parsedFee,
                                        'status': 'Pending',
                                        'dueDate': '2026-10-31',
                                        'type': 'Annual Tuition Fee',
                                        'createdAt': FieldValue.serverTimestamp(),
                                      });

                                      // 3. Create linked Parent user record for Parent Portal access
                                      final parentUserRef = _firestore.collection('users').doc();
                                      final String parentEmail = 'parent.${formattedStudentId.toLowerCase()}@cityschool.edu';
                                      await parentUserRef.set({
                                        'name': parentName,
                                        'email': parentEmail,
                                        'phone': parentPhone,
                                        'phoneNumber': parentPhone,
                                        'roles': ['parent'],
                                        'schoolId': schoolVal,
                                        'childrenIds': [userRef.id],
                                        'childStudentId': userRef.id,
                                        'childName': nameController.text.trim(),
                                        'childGrade': gradeVal,
                                        'childSection': sectionVal,
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
                                    : Text('Save Student', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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
    bool isPassword = false,
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
          obscureText: isPassword,
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

  void _confirmDeleteStudent(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Student?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: Text(
            'Are you sure you want to delete this student profile? This action cannot be undone.',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('users').doc(uid).delete();
                if (mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
