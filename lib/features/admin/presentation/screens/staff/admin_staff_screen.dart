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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRole = 'All';

  final List<String> _roles = ['All', 'staff', 'teacher', 'admin'];

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
                      'Staff Directory',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF131742),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage educators, faculty & roles',
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
                onPressed: () => _showAddStaffDialog(context, currentSchool),
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                label: const Text('Add Staff'),
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
                  // Full-width search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search staff by name, email or subject...',
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
                  // Role Filter Dropdown Row
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131742)),
                        items: _roles.map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                            r == 'All' ? 'All Staff Roles' : 'Role: ${r.toUpperCase()}',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedRole = val!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Staff List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.badge_outlined, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No staff records found.', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
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
                  staffList = staffList.where((s) =>
                    s.name.toLowerCase().contains(_searchQuery) ||
                    s.email.toLowerCase().contains(_searchQuery) ||
                    (s.subject != null && s.subject!.toLowerCase().contains(_searchQuery)) ||
                    (s.phone != null && s.phone!.toLowerCase().contains(_searchQuery))
                  ).toList();
                }
                if (_selectedRole != 'All') {
                  staffList = staffList.where((s) => s.roles.contains(_selectedRole.toLowerCase())).toList();
                }

                if (staffList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No staff match the search filters.', style: GoogleFonts.inter(color: Colors.grey)),
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
                              DataColumn(label: Text('Teaching Subject')),
                              DataColumn(label: Text('Phone / Mobile')),
                              DataColumn(label: Text('School')),
                              DataColumn(label: Text('Role(s)')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: staffList.map((s) {
                              return DataRow(
                                onSelectChanged: (_) => _showStaffDetailsDialog(context, s),
                                cells: [
                                  DataCell(Text(_capitalize(s.name), style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE28743).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        s.displaySubject,
                                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFE28743)),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(s.displayPhone, style: GoogleFonts.inter(fontSize: 12))),
                                  DataCell(Text(_formatSchool(s.schoolId))),
                                  DataCell(Text(s.roles.join(', ').toUpperCase())),
                                  DataCell(Text(s.email)),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility_outlined, color: Color(0xFF131742), size: 18),
                                          onPressed: () => _showStaffDetailsDialog(context, s),
                                          tooltip: 'View Details',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, color: Color(0xFFE28743), size: 18),
                                          onPressed: () => _showEditStaffDialog(context, s),
                                          tooltip: 'Edit Staff',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                                          onPressed: () => _confirmDeleteStaff(context, s.uid),
                                          tooltip: 'Delete Staff',
                                        ),
                                      ],
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
                        itemCount: staffList.length,
                        itemBuilder: (context, index) {
                          final s = staffList[index];
                          return _buildStaffMobileCard(s);
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

  Widget _buildStaffMobileCard(UserModel s) {
    String initial = s.name.isNotEmpty ? s.name[0].toUpperCase() : 'T';
    String roleLabel = s.roles.isNotEmpty ? s.roles.first.toUpperCase() : 'STAFF';

    Color roleColor = const Color(0xFF131742);
    if (s.isAdmin) roleColor = Colors.purple;
    if (s.roles.contains('teacher')) roleColor = const Color(0xFFE28743);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showStaffDetailsDialog(context, s),
        borderRadius: BorderRadius.circular(16),
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
                backgroundColor: roleColor.withOpacity(0.08),
                child: Text(
                  initial,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _capitalize(s.name),
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF131742),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            roleLabel,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: roleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Subject and Phone pills
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE28743).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_rounded, size: 11, color: Color(0xFFE28743)),
                              const SizedBox(width: 4),
                              Text(
                                s.displaySubject,
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFE28743)),
                              ),
                            ],
                          ),
                        ),
                        if (s.phone != null && s.phone!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.phone_rounded, size: 11, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  s.phone!,
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green.shade800),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
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
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            s.email,
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFFE28743), size: 18),
                onPressed: () => _showEditStaffDialog(context, s),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                onPressed: () => _confirmDeleteStaff(context, s.uid),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStaffDetailsDialog(BuildContext context, UserModel staff) {
    String initial = staff.name.isNotEmpty ? staff.name[0].toUpperCase() : 'T';
    Color roleColor = const Color(0xFF131742);
    if (staff.isAdmin) roleColor = Colors.purple;
    if (staff.roles.contains('teacher')) roleColor = const Color(0xFFE28743);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Card
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: roleColor.withOpacity(0.12),
                        child: Text(
                          initial,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: roleColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _capitalize(staff.name),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF131742),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: roleColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    staff.roles.join(', ').toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: roleColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF131742).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _formatSchool(staff.schoolId),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                ),
                              ],
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

                  // Teaching Subject Card
                  _buildDetailRow(
                    icon: Icons.menu_book_rounded,
                    label: 'Teaching Subject / Specialization',
                    value: staff.displaySubject,
                    valueColor: const Color(0xFFE28743),
                    isHighlight: true,
                  ),
                  const SizedBox(height: 12),

                  // Phone / Mobile Number
                  _buildDetailRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone / Mobile Number',
                    value: staff.displayPhone,
                    valueColor: const Color(0xFF131742),
                  ),
                  const SizedBox(height: 12),

                  // Email Address
                  _buildDetailRow(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: staff.email,
                  ),
                  const SizedBox(height: 12),

                  // School Campus
                  _buildDetailRow(
                    icon: Icons.business_rounded,
                    label: 'School Campus',
                    value: _formatSchool(staff.schoolId),
                  ),
                  const SizedBox(height: 12),

                  // Staff Attendance Record
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('attendance')
                        .where('userId', isEqualTo: staff.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      int total = 0;
                      int presentCount = 0;
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        for (var doc in snapshot.data!.docs) {
                          final d = doc.data() as Map<String, dynamic>;
                          total++;
                          if (d['status'] == 'Present' || d['present'] == true) {
                            presentCount++;
                          }
                        }
                      }
                      double attendanceRate = total > 0 ? (presentCount / total) * 100 : 96.0;
                      String displayRate = '${attendanceRate.toStringAsFixed(1)}%';
                      String statusLabel = total > 0 ? (presentCount > 0 ? 'Present Today' : 'Absent') : 'Present (Active)';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.green),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Faculty Attendance & Duty Log',
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        displayRate,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          statusLabel,
                                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22),

                  // Action Buttons (Close + Edit)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF131742),
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Close', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _showEditStaffDialog(context, staff);
                          },
                          icon: const Icon(Icons.edit_rounded, size: 17, color: Colors.white),
                          label: Text('Edit Details', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE28743),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditStaffDialog(BuildContext context, UserModel staff) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: staff.name);
    final subjectController = TextEditingController(text: staff.subject ?? (staff.displaySubject == 'General Faculty' ? '' : staff.displaySubject));
    final phoneController = TextEditingController(text: staff.phone ?? (staff.displayPhone == 'Not provided' ? '' : staff.displayPhone));
    String schoolVal = _normalizeSchoolId(staff.schoolId);
    String roleVal = 'teacher';
    if (staff.roles.contains('admin')) {
      roleVal = 'admin';
    } else if (staff.roles.contains('staff')) {
      roleVal = 'staff';
    } else {
      roleVal = 'teacher';
    }
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
                              child: const Icon(Icons.edit_note_rounded, color: Color(0xFFE28743), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Staff Profile',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                  Text(
                                    'Update faculty details & subject specialization',
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
                          label: 'Full Name',
                          hint: 'Enter full name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter name' : null,
                        ),
                        const SizedBox(height: 14),

                        // Subject & Phone
                        _buildInputField(
                          controller: subjectController,
                          label: 'Teaching Subject / Specialization',
                          hint: 'e.g. Mathematics, Science, English, Physics',
                          icon: Icons.menu_book_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter subject' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: phoneController,
                          label: 'Mobile / Phone Number',
                          hint: '+91 98765 43210',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter phone number' : null,
                        ),
                        const SizedBox(height: 14),

                        // Email (Display only)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email Address (Login ID)',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                staff.email,
                                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700),
                              ),
                            ),
                          ],
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

                        // Role dropdown
                        _buildDropdownField(
                          label: 'Designation Role',
                          icon: Icons.assignment_ind_outlined,
                          value: roleVal,
                          items: const [
                            DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                            DropdownMenuItem(value: 'staff', child: Text('Administrative Staff')),
                            DropdownMenuItem(value: 'admin', child: Text('System Admin')),
                          ],
                          onChanged: (val) => setDialogState(() => roleVal = val!),
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
                                      await _firestore.collection('users').doc(staff.uid).update({
                                        'name': nameController.text.trim(),
                                        'subject': subjectController.text.trim(),
                                        'teachingSubject': subjectController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                        'phoneNumber': phoneController.text.trim(),
                                        'schoolId': schoolVal,
                                        'roles': [roleVal],
                                        'updatedAt': FieldValue.serverTimestamp(),
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
                                    : Text('Save Changes', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (valueColor ?? const Color(0xFF131742)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: valueColor ?? const Color(0xFF131742)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                    color: valueColor ?? const Color(0xFF131742),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map((str) => str.isNotEmpty ? str[0].toUpperCase() + str.substring(1).toLowerCase() : '').join(' ');
  }

  String _normalizeSchoolId(String? id) {
    if (id == null) return 'city_talent';
    final clean = id.toLowerCase().replaceAll('-', '_');
    if (clean.contains('elite')) return 'city_elite';
    if (clean.contains('vision')) return 'new_vision';
    return 'city_talent';
  }

  String _formatSchool(String? id) {
    if (id == null) return 'N/A';
    final clean = id.toLowerCase().replaceAll('-', '_');
    if (clean.contains('talent')) return 'City Talent School';
    if (clean.contains('elite')) return 'City Elite School';
    if (clean.contains('vision')) return 'New Vision High School';
    return id;
  }

  void _showAddStaffDialog(BuildContext context, String initialSchool) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final subjectController = TextEditingController(text: 'Mathematics');
    final phoneController = TextEditingController();
    String schoolVal = initialSchool == 'all' ? 'city_talent' : initialSchool;
    String roleVal = 'teacher';
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
                              child: const Icon(Icons.badge_rounded, color: Color(0xFFE28743), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Staff',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF131742),
                                    ),
                                  ),
                                  Text(
                                    'Register faculty, subject & contact details',
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
                          label: 'Full Name',
                          hint: 'Enter full name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter name' : null,
                        ),
                        const SizedBox(height: 14),

                        // Subject & Phone
                        _buildInputField(
                          controller: subjectController,
                          label: 'Teaching Subject / Specialization',
                          hint: 'e.g. Mathematics, Science, English, Physics',
                          icon: Icons.menu_book_rounded,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter subject' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: phoneController,
                          label: 'Mobile / Phone Number',
                          hint: '+91 98765 43210',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter phone number' : null,
                        ),
                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: emailController,
                          label: 'Email Address',
                          hint: 'teacher@cityschool.edu',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter email';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
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

                        // Role dropdown
                        _buildDropdownField(
                          label: 'Designation Role',
                          icon: Icons.assignment_ind_outlined,
                          value: roleVal,
                          items: const [
                            DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                            DropdownMenuItem(value: 'staff', child: Text('Administrative Staff')),
                            DropdownMenuItem(value: 'admin', child: Text('System Admin')),
                          ],
                          onChanged: (val) => setDialogState(() => roleVal = val!),
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
                                      await userRef.set({
                                        'name': nameController.text.trim(),
                                        'email': emailController.text.trim(),
                                        'subject': subjectController.text.trim(),
                                        'teachingSubject': subjectController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                        'phoneNumber': phoneController.text.trim(),
                                        'roles': [roleVal],
                                        'schoolId': schoolVal,
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
                                    : Text('Save Staff', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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

  void _confirmDeleteStaff(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Remove Staff Member?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: Text(
            'Are you sure you want to delete this staff profile? This action cannot be undone.',
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
