import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';

class AdminAcademicsScreen extends StatefulWidget {
  const AdminAcademicsScreen({super.key});

  @override
  State<AdminAcademicsScreen> createState() => _AdminAcademicsScreenState();
}

class _AdminAcademicsScreenState extends State<AdminAcademicsScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;

  final List<String> _classes = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _sections = ['A', 'B', 'C'];
  final List<String> _subjects = ['Telugu', 'English', 'Hindi', 'Mathematics', 'Physical Science', 'Biological Science', 'Social Studies'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic Management',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131742),
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFE28743),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFE28743),
            tabs: const [
              Tab(text: 'Classes', icon: Icon(Icons.class_rounded)),
              Tab(text: 'Sections', icon: Icon(Icons.layers_rounded)),
              Tab(text: 'Subjects', icon: Icon(Icons.menu_book_rounded)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListCard('Classes Available', _classes, Icons.school),
                _buildListCard('Active Sections', _sections, Icons.layers),
                _buildListCard('Course Curriculum Subjects', _subjects, Icons.book),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(String title, List<String> items, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF131742)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF131742),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF131742).withOpacity(0.05),
                      child: Text((index + 1).toString(), style: const TextStyle(color: Color(0xFF131742))),
                    ),
                    title: Text(items[index], style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
