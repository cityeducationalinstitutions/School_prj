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
  String _searchQuery = '';
  String _selectedGrade = 'All';
  String _selectedSection = 'All';

  final List<String> _grades = ['All', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _sections = ['All', 'A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final String currentSchool = adminProvider.selectedSchoolId;

    return Padding(
      padding: const EdgeInsets.all(24),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF131742),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage enrollment & credentials',
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE28743),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by student name...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                  ),
                  const SizedBox(height: 12),
                  Row(
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSection,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              items: _sections.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
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
          const SizedBox(height: 24),

          // Students List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').where('roles', arrayContains: 'student').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No students found.'));
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
                  students = students.where((s) => s.name.toLowerCase().contains(_searchQuery)).toList();
                }
                if (_selectedGrade != 'All') {
                  students = students.where((s) => s.grade == _selectedGrade).toList();
                }
                if (_selectedSection != 'All') {
                  students = students.where((s) => s.section == _selectedSection).toList();
                }

                if (students.isEmpty) {
                  return const Center(child: Text('No students match the filters.'));
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
        margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
            radius: 24,
            backgroundColor: const Color(0xFF131742).withOpacity(0.08),
            child: Text(
              initial,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF131742),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalize(s.name),
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF131742),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.business_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _formatSchool(s.schoolId),
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
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
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE28743),
                        ),
                      ),
                    ),
                    if (s.section != null && s.section != 'N/A') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131742).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Sec ${s.section}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
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
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
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
    String schoolVal = initialSchool == 'all' ? 'city_talent' : initialSchool;
    String gradeVal = 'Class 1';
    String sectionVal = 'A';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Student Name'),
                    validator: (v) => v!.isEmpty ? 'Name required' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v!.isEmpty ? 'Email required' : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password (Temporary)'),
                    obscureText: true,
                    validator: (v) => v!.length < 6 ? 'Password min 6 chars' : null,
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
                    value: gradeVal,
                    decoration: const InputDecoration(labelText: 'Class'),
                    items: _grades.where((g) => g != 'All').map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => gradeVal = val!,
                  ),
                  DropdownButtonFormField<String>(
                    value: sectionVal,
                    decoration: const InputDecoration(labelText: 'Section'),
                    items: _sections.where((s) => s != 'All').map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => sectionVal = val!,
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
                  final userRef = _firestore.collection('users').doc();
                  await userRef.set({
                    'name': nameController.text.trim(),
                    'email': emailController.text.trim(),
                    'roles': ['student'],
                    'schoolId': schoolVal,
                    'grade': gradeVal,
                    'section': sectionVal,
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

  void _confirmDeleteStudent(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student?'),
          content: const Text('Are you sure you want to delete this student profile?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('users').doc(uid).delete();
                if (mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
