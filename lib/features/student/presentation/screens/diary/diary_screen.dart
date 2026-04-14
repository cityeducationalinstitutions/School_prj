import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/academic_models.dart';

class StudentDiaryScreen extends StatefulWidget {
  const StudentDiaryScreen({super.key});

  @override
  State<StudentDiaryScreen> createState() => _StudentDiaryScreenState();
}

class _StudentDiaryScreenState extends State<StudentDiaryScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showAssignments = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchDiary());
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    const Color bgLight = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: Text(
          'Daily Learning Diary',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: schoolBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_showAssignments)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: schoolOrange.withOpacity(0.1),
                child: IconButton(
                  icon: const Icon(Icons.calendar_month_rounded, color: schoolOrange, size: 18),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      studentProvider.fetchDiaryForDate(picked);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: schoolBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton(
                        label: 'DAILY LESSONS',
                        isActive: !_showAssignments,
                        onTap: () => setState(() => _showAssignments = false),
                        navy: schoolBlue,
                      ),
                      _buildToggleButton(
                        label: 'ASSIGNMENTS',
                        isActive: _showAssignments,
                        onTap: () => setState(() => _showAssignments = true),
                        navy: schoolBlue,
                      ),
                    ],
                  ),
                ),
                if (!_showAssignments) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PremiumDateNavButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () {
                          final newDate = _selectedDate.subtract(const Duration(days: 1));
                          setState(() => _selectedDate = newDate);
                          studentProvider.fetchDiaryForDate(newDate);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('EEEE').format(_selectedDate).toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: schoolOrange,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM, yyyy').format(_selectedDate),
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: schoolBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _PremiumDateNavButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: _selectedDate.isBefore(DateTime.now().subtract(const Duration(seconds: 1))) 
                            ? () {
                                final newDate = _selectedDate.add(const Duration(days: 1));
                                setState(() => _selectedDate = newDate);
                                studentProvider.fetchDiaryForDate(newDate);
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: studentProvider.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _showAssignments 
                    ? (studentProvider.upcomingAssignments.isEmpty 
                        ? _buildEmptyView('Great Job!', 'No pending assignments today.', schoolBlue)
                        : ListView.builder(
                            padding: const EdgeInsets.all(24),
                            physics: const BouncingScrollPhysics(),
                            itemCount: studentProvider.upcomingAssignments.length,
                            itemBuilder: (context, index) => _buildAssignmentCard(
                              studentProvider.upcomingAssignments[index],
                              schoolOrange,
                              schoolBlue,
                              bgLight,
                            ),
                          ))
                    : (() {
                        final filteredEntries = studentProvider.diaryEntries.where((e) => 
                          DateUtils.isSameDay(e.date, _selectedDate)
                        ).toList();

                        if (filteredEntries.isEmpty) {
                          return _buildEmptyView(
                            'A New Opportunity!', 
                            'No formal lessons recorded for ${DateFormat('dd MMM').format(_selectedDate)}. Stay curious and keep exploring your academic goals!', 
                            schoolBlue
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(24),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
                            return _PremiumDiaryEntryCard(
                              subject: entry.subject,
                              topic: entry.topic,
                              homework: entry.homework,
                            );
                          },
                        );
                      })()),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({required String label, required bool isActive, required VoidCallback onTap, required Color navy}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive 
              ? [BoxShadow(color: navy.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isActive ? navy : navy.withOpacity(0.4),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(String title, String subtitle, Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_stories_rounded, size: 60, color: navy.withOpacity(0.1)),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 22,
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: navy.withOpacity(0.4),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(DiaryEntry task, Color orange, Color navy, Color bg) {
    int daysLeft = task.date.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    task.subject.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: orange,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Spacer(),
                if (daysLeft <= 2 && daysLeft >= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'URGENT',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Home Academic Mission',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.homework,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: navy.withOpacity(0.5),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 16, color: orange),
                const SizedBox(width: 8),
                Text(
                   'Assigned: ${DateFormat('dd MMM, yyyy').format(task.date)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navy.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                Text(
                  'PENDING',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: orange,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumDateNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _PremiumDateNavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.transparent : const Color(0xFF131742).withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon, 
          color: onTap == null ? Colors.grey.shade300 : const Color(0xFF131742),
          size: 28,
        ),
      ),
    );
  }
}

class _PremiumDiaryEntryCard extends StatelessWidget {
  final String subject;
  final String topic;
  final String homework;

  const _PremiumDiaryEntryCard({
    required this.subject,
    required this.topic,
    required this.homework,
  });

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    const Color bgLight = Color(0xFFF8F9FE);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: schoolBlue.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [schoolOrange, schoolOrange.withOpacity(0.6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: schoolOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              subject.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: schoolOrange,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.verified_rounded, color: Colors.green, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        topic,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: schoolBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Class proceedings and detailed topic analysis for effective learning.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: schoolBlue.withOpacity(0.5),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.assignment_rounded, color: schoolOrange, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HOMEWORK',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: schoolBlue.withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    homework.isEmpty ? 'No homework assigned' : homework,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: schoolOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
