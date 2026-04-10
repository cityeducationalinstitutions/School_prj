import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';

class StudentExamsScreen extends StatefulWidget {
  const StudentExamsScreen({super.key});

  @override
  State<StudentExamsScreen> createState() => _StudentExamsScreenState();
}

class _StudentExamsScreenState extends State<StudentExamsScreen> {
  String _selectedType = 'All';
  final List<String> _types = ['All', 'Weekly', 'Unit Test', 'Quarterly', 'Half-Yearly', 'Final'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchExams());
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    // Filter exams based on selected type
    final filteredExams = studentProvider.exams.where((exam) {
      if (_selectedType == 'All') return true;
      if (_selectedType == 'Weekly') return exam.type.toLowerCase().contains('weekly');
      if (_selectedType == 'Unit Test') return exam.type.toLowerCase().contains('unit');
      if (_selectedType == 'Quarterly') return exam.type.toLowerCase().contains('quarterly');
      if (_selectedType == 'Half-Yearly') return exam.type.toLowerCase().contains('half');
      if (_selectedType == 'Final') return exam.type.toLowerCase().contains('final');
      return true;
    }).toList();

    // Calculate countdown for the next exam (using ALL exams for overall awareness)
    String countdownText = 'No Upcoming Exams';
    if (studentProvider.exams.isNotEmpty) {
      final nextExam = studentProvider.exams.first;
      final days = nextExam.date.difference(DateTime.now()).inDays;
      if (days < 0) {
        countdownText = 'Examination in Progress';
      } else if (days == 0) {
        countdownText = 'EXAM TODAY';
      } else {
        countdownText = 'Starts in $days Days';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Signature Elite Countdown Header (Immersive Orange)
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: schoolOrange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  // Branded Orange Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [schoolOrange, schoolOrange.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative Navy Accents (Senior Dev Aesthetic)
                  Positioned(
                    right: -40,
                    top: -40,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: schoolBlue.withOpacity(0.06),
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
                            color: schoolBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'EXAM MISSION CENTER',
                            style: GoogleFonts.inter(color: schoolBlue, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Exam Schedule',
                          style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: schoolBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16, color: schoolBlue.withOpacity(0.6)),
                            const SizedBox(width: 8),
                            Text(
                              countdownText,
                              style: GoogleFonts.inter(fontSize: 14, color: schoolBlue.withOpacity(0.6), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Elite Mission Filter Strip (Sticky)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverFilterDelegate(
              child: Container(
                height: 80,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _types.length,
                  itemBuilder: (context, index) {
                    final type = _types[index];
                    final isSelected = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedType = type);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? schoolOrange : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [BoxShadow(color: schoolOrange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                                : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                            border: Border.all(color: isSelected ? schoolOrange : Colors.grey.shade100, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              type,
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

          // 3. Vertical Chronological Timeline Content
          studentProvider.isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: schoolOrange)))
              : filteredExams.isEmpty
                  ? SliverToBoxAdapter(child: _EmptyEliteView(schoolBlue, _selectedType))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 60),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final exam = filteredExams[index];
                            final isLast = index == filteredExams.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left-side Timeline Anchor
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: schoolOrange,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 3),
                                            boxShadow: [BoxShadow(color: schoolOrange.withOpacity(0.3), blurRadius: 6)],
                                          ),
                                        ),
                                        if (!isLast)
                                          Expanded(
                                            child: Container(
                                              width: 2,
                                              color: schoolBlue.withOpacity(0.1),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Main Exam Card (Elite V1)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      child: _EliteExamCard(exam: exam),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: filteredExams.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

class _EliteExamCard extends StatelessWidget {
  final exam; // ExamSchedule type
  const _EliteExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    
    final daysRemaining = exam.date.difference(DateTime.now()).inDays;
    final isUpcomingSoon = daysRemaining >= 0 && daysRemaining <= 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // Header Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isUpcomingSoon ? schoolOrange.withOpacity(0.08) : schoolBlue.withOpacity(0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exam.type.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: isUpcomingSoon ? schoolOrange : schoolBlue.withOpacity(0.4),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (isUpcomingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: schoolOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          // Content Padding
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Premium Date Block
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: schoolBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMM').format(exam.date).toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5)),
                      ),
                      Text(
                        exam.date.day.toString(),
                        style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Subject and Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.subject,
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: schoolBlue),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: schoolOrange),
                          const SizedBox(width: 6),
                          Text(
                            exam.time.format(context),
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.room_rounded, size: 14, color: schoolOrange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              exam.room ?? 'Main Hall',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverFilterDelegate({required this.child});

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
  bool shouldRebuild(covariant _SliverFilterDelegate oldDelegate) => true;
}

class _EmptyEliteView extends StatelessWidget {
  final Color navy;
  final String selectedType;
  const _EmptyEliteView(this.navy, this.selectedType);

  @override
  Widget build(BuildContext context) {
    String message = 'No upcoming exams';
    if (selectedType != 'All') {
      message = 'All $selectedType assessment missions completed';
    }

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
              child: Icon(Icons.event_available_rounded, size: 70, color: navy.withOpacity(0.08)),
            ),
            const SizedBox(height: 32),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'You have successfully completed all scheduled assessments for this session.',
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
