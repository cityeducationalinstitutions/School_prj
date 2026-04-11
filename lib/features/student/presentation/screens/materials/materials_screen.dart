import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/features/student/presentation/screens/quiz/quiz_screen.dart';
import 'package:management/models/academic_models.dart';

class StudentMaterialsScreen extends StatefulWidget {
  const StudentMaterialsScreen({super.key});

  @override
  State<StudentMaterialsScreen> createState() => _StudentMaterialsScreenState();
}

class _StudentMaterialsScreenState extends State<StudentMaterialsScreen> {
  String _selectedSubject = 'All';
  final List<String> _subjects = ['All', 'Mathematics', 'Science', 'English', 'Social Studies', 'Telugu'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchMaterials(_selectedSubject));
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Signature Elite Header (Immersive)
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: schoolBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  // Branded Gradient Layer
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [schoolOrange, schoolOrange.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Signature Accent
                  Positioned(
                    right: -50,
                    top: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: schoolBlue.withOpacity(0.08),
                    ),
                  ),
                  // Dashboard Content
                  Positioned(
                    bottom: 30,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ACADEMIC HUB',
                            style: GoogleFonts.inter(color: schoolBlue, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Learning Materials',
                          style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: schoolBlue),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Select a subject to explore its resources',
                          style: GoogleFonts.inter(fontSize: 13, color: schoolBlue.withOpacity(0.6), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Elite Subject Filter Strip (Sticky)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverSubjectFilterDelegate(
              child: Container(
                height: 80,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    final isSelected = _selectedSubject == subject;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedSubject = subject);
                          studentProvider.fetchMaterials(subject);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? schoolBlue : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [BoxShadow(color: schoolBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                                : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                            border: Border.all(color: isSelected ? schoolBlue : Colors.grey.shade100, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              subject,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. Materials Content
          studentProvider.isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: schoolOrange)))
              : studentProvider.materials.isEmpty
                  ? SliverToBoxAdapter(child: _EmptyEliteView(schoolBlue))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final material = studentProvider.materials[index];
                            return _EliteMaterialCard(
                              material: material,
                              onView: () {
                                // TODO: Implement PDF Viewer
                              },
                              onGenerateQuiz: () async {
                                _handleQuizGeneration(context, studentProvider, material.id);
                              },
                            );
                          },
                          childCount: studentProvider.materials.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Future<void> _handleQuizGeneration(BuildContext context, StudentProvider provider, String materialId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFE28743))),
      );
      await provider.startQuizFromMaterial(materialId);
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate quiz: $e')));
      }
    }
  }
}

class _SliverSubjectFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverSubjectFilterDelegate({required this.child});

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverSubjectFilterDelegate oldDelegate) => true;
}

class _EliteMaterialCard extends StatelessWidget {
  final AcademicMaterial material; // AcademicMaterial type
  final VoidCallback onView;
  final VoidCallback onGenerateQuiz;

  const _EliteMaterialCard({required this.material, required this.onView, required this.onGenerateQuiz});

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Signature Glassmorphic Icon
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Icon(Icons.picture_as_pdf_rounded, color: Colors.pinkAccent, size: 28),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title,
                        style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: schoolBlue),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: schoolBlue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              material.subject.toUpperCase(),
                              style: GoogleFonts.inter(fontSize: 9, color: schoolBlue.withOpacity(0.5), fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${DateFormat('dd MMM').format(material.createdAt)}',
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade50),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text('OPEN RESOURCE'),
                    style: TextButton.styleFrom(
                      foregroundColor: schoolBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGenerateQuiz,
                    icon: const Icon(Icons.bolt_rounded, size: 18),
                    label: const Text('GENERATE QUIZ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: schoolOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shadowColor: schoolOrange.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEliteView extends StatelessWidget {
  final Color navy;
  const _EmptyEliteView(this.navy);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: navy.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_copy_rounded, size: 70, color: navy.withOpacity(0.08)),
            ),
            const SizedBox(height: 32),
            Text(
              'No materials found',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'New study resources will appear here once they are published for your class.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: navy.withOpacity(0.4), height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
