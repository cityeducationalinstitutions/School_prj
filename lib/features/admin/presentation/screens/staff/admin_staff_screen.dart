import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';
import 'package:management/models/user_model.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String _selectedRole = 'All';

  final List<String> _roles = ['All', 'staff', 'teacher', 'admin'];

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
                'Staff & Teachers Directory',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddStaffDialog(context, currentSchool),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Staff member'),
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
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search staff by name...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => _selectedRole = val!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Staff List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No staff records found.'));
                }

                // Filter users who are not students or parents
                List<UserModel> staffList = snapshot.data!.docs.map((doc) {
                  return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).where((u) => u.isStaff || u.isAdmin || u.roles.contains('teacher')).toList();

                // Apply school filter
                if (currentSchool != 'all') {
                  staffList = staffList.where((s) => s.schoolId == currentSchool).toList();
                }

                // Apply Search & Role filters
                if (_searchQuery.isNotEmpty) {
                  staffList = staffList.where((s) => s.name.toLowerCase().contains(_searchQuery)).toList();
                }
                if (_selectedRole != 'All') {
                  staffList = staffList.where((s) => s.roles.contains(_selectedRole.toLowerCase())).toList();
                }

                if (staffList.isEmpty) {
                  return const Center(child: Text('No staff match the filters.'));
                }

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('School')),
                        DataColumn(label: Text('Role(s)')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: staffList.map((s) {
                        return DataRow(
                          cells: [
                            DataCell(Text(s.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                            DataCell(Text(s.schoolId ?? 'N/A')),
                            DataCell(Text(s.roles.join(', ').toUpperCase())),
                            DataCell(Text(s.email)),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDeleteStaff(context, s.uid),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStaffDialog(BuildContext context, String initialSchool) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String schoolVal = initialSchool == 'all' ? 'city_talent' : initialSchool;
    String roleVal = 'teacher';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Staff Member'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v!.isEmpty ? 'Name required' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v!.isEmpty ? 'Email required' : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v!.length < 6 ? 'Password min 6 chars' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: schoolVal,
                    decoration: const InputDecoration(labelText: 'School Assignment'),
                    items: const [
                      DropdownMenuItem(value: 'city_talent', child: Text('City Talent School')),
                      DropdownMenuItem(value: 'city_elite', child: Text('City Elite School')),
                      DropdownMenuItem(value: 'new_vision', child: Text('New Vision High School')),
                    ],
                    onChanged: (val) => schoolVal = val!,
                  ),
                  DropdownButtonFormField<String>(
                    value: roleVal,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: const [
                      DropdownMenuItem(value: 'teacher', child: Text('TEACHER')),
                      DropdownMenuItem(value: 'staff', child: Text('STAFF')),
                      DropdownMenuItem(value: 'admin', child: Text('ADMIN')),
                    ],
                    onChanged: (val) => roleVal = val!,
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
                    'roles': [roleVal],
                    'schoolId': schoolVal,
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

  void _confirmDeleteStaff(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Staff Member?'),
          content: const Text('Are you sure you want to delete this staff profile?'),
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
