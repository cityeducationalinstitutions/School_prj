import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/models/school_model.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/features/student/presentation/screens/attendance/attendance_screen.dart';
import 'package:management/features/student/presentation/screens/exams/exams_screen.dart';
import 'package:management/features/student/presentation/screens/gradebook/gradebook_screen.dart';
import 'package:management/features/student/presentation/screens/materials/materials_screen.dart';
import 'package:management/features/student/presentation/screens/schedule/schedule_screen.dart';
import 'package:management/features/student/presentation/screens/doubts/doubts_main_screen.dart';
import 'package:management/features/student/presentation/screens/notifications/notifications_screen.dart';
import 'package:intl/intl.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/main.dart';

class StudentPortalMain extends StatefulWidget {
  const StudentPortalMain({super.key});

  @override
  State<StudentPortalMain> createState() => _StudentPortalMainState();
}

class _StudentPortalMainState extends State<StudentPortalMain> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const StudentHomeTab(),
    const StudentDiaryTab(),
    const StudentProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: schoolOrange,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class StudentHomeTab extends StatelessWidget {
  const StudentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final studentProvider = context.watch<StudentProvider>();
    final user = authProvider.currentUser;
    final selectedSchoolId = authProvider.selectedSchoolId;
    
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _HeaderSection(
            schoolName: school.name,
            themeColor: schoolOrange,
            logoPath: school.logoPath,
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: _GreetingCard(
                      name: user?.name ?? 'Student',
                      themeColor: schoolOrange,
                    ),
                  ),
                ),


                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Academic Progress',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF131742),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _SummaryCard(
                                title: 'Attendance',
                                value: () {
                                  final now = DateTime.now();
                                  final currentMonthRecords = studentProvider.monthlyAttendance.where((r) => 
                                    r.date.month == now.month && r.date.year == now.year
                                  ).toList();

                                  if (currentMonthRecords.isEmpty) return '0%';
                                  
                                  final total = currentMonthRecords.length;
                                  final present = currentMonthRecords.where((r) => 
                                    r.status.toLowerCase() == 'present'
                                  ).length;
                                  
                                  return '${((present / total) * 100).toInt()}%';
                                }(),
                                subtitle: 'Current Month',
                                icon: Icons.calendar_today_rounded,
                                color: Colors.blue.shade700,
                              ),
                              _SummaryCard(
                                title: 'Performance',
                                value: 'A+',
                                subtitle: 'Top 10%',
                                icon: Icons.stars_rounded,
                                color: schoolOrange,
                              ),
                              _SummaryCard(
                                title: 'Last Quiz',
                                value: '8/10',
                                subtitle: 'Mathematics',
                                icon: Icons.quiz_rounded,
                                color: Colors.green.shade700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildListDelegate([
                      _QuickActionCard(
                        title: 'Grade Book',
                        subtitle: 'Marks & Results',
                        imagePath: 'assets/icons/3d_gradebook.png',
                        color: Colors.deepPurple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentGradebookScreen()),
                        ),
                      ),
                      _QuickActionCard(
                        title: 'Materials',
                        subtitle: 'PDFs & Quizzes',
                        imagePath: 'assets/icons/3d_materials.png',
                        color: Colors.amber.shade400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentMaterialsScreen()),
                        ),
                      ),
                      _QuickActionCard(
                        title: 'Exams',
                        subtitle: 'Schedules',
                        imagePath: 'assets/icons/exams.png',
                        color: Colors.red.shade400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentExamsScreen()),
                        ),
                      ),
                      _QuickActionCard(
                        title: 'Attendance',
                        subtitle: 'History',
                        imagePath: 'assets/icons/3d_attendance.png',
                        color: Colors.teal.shade400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentAttendanceScreen()),
                        ),
                      ),
                      _QuickActionCard(
                        title: 'Schedule',
                        subtitle: 'Timetable',
                        imagePath: 'assets/icons/Schedule.png',
                        color: Colors.indigo.shade400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                        ),
                      ),
                      _QuickActionCard(
                        title: 'Doubts',
                        subtitle: 'Ask Teacher',
                        imagePath: 'assets/icons/3d_doubts.jpg',
                        color: Colors.pink.shade400,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DoubtsMainScreen()),
                        ),
                      ),
                    ]),
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

class _HeaderSection extends StatelessWidget {
  final String schoolName;
  final Color themeColor;
  final String logoPath;
  const _HeaderSection({
    required this.schoolName,
    required this.themeColor,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/images/header_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: _NotificationBadge(themeColor: themeColor),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(child: Image.asset(logoPath, fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      schoolName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        letterSpacing: 0.3,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String name;
  final Color themeColor;

  const _GreetingCard({
    required this.name,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF131742);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   Text(
                    'Good Day,',
                    style: GoogleFonts.inter(
                      color: primaryNavy.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🚀', style: TextStyle(fontSize: 20)),
                ],
              ),
              Icon(
                Icons.wb_sunny_rounded,
                color: themeColor.withOpacity(0.15),
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.playfairDisplay(
              color: themeColor,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'STUDENT APPRENTICE',
              style: TextStyle(
                color: themeColor,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentDiaryTab extends StatefulWidget {
  const StudentDiaryTab({super.key});

  @override
  State<StudentDiaryTab> createState() => _StudentDiaryTabState();
}

class _StudentDiaryTabState extends State<StudentDiaryTab> {
  DateTime _selectedDate = DateTime.now();
  final ScrollController _dateController = ScrollController();
  bool _showAssignments = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchDiary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    const Color bgLight = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: bgLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Learning Diary',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: schoolBlue,
              ),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: schoolBlue.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: schoolOrange.withOpacity(0.1),
              child: IconButton(
                icon: const Icon(Icons.calendar_today_rounded, color: schoolOrange, size: 20),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: schoolOrange,
                            onPrimary: Colors.white,
                            onSurface: schoolBlue,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      // In the new system, diary fetch is class-wide, 
                      // but we could filter locally by date if needed.
                    }
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // PREMIUM TOGGLE & DATE STRIP
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                // Premium Toggle Switch
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: schoolBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAssignments = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_showAssignments ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_showAssignments 
                                ? [BoxShadow(color: schoolBlue.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                                : [],
                            ),
                            child: Center(
                              child: Text(
                                'DAILY LESSONS',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: !_showAssignments ? schoolBlue : schoolBlue.withOpacity(0.4),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAssignments = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _showAssignments ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _showAssignments 
                                ? [BoxShadow(color: schoolBlue.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                                : [],
                            ),
                            child: Center(
                              child: Text(
                                'ASSIGNMENTS',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _showAssignments ? schoolBlue : schoolBlue.withOpacity(0.4),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (!_showAssignments)
                  SizedBox(
                    height: 65,
                    child: ListView.builder(
                      controller: _dateController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      physics: const BouncingScrollPhysics(),
                      itemCount: 30, // Show last 30 days
                      itemBuilder: (context, index) {
                        final date = DateTime.now().subtract(Duration(days: index));
                        final isSelected = DateUtils.isSameDay(date, _selectedDate);
                        
                        return Container(
                          width: 58,
                          margin: const EdgeInsets.only(right: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (!isSelected) {
                                  setState(() => _selectedDate = date);
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              splashColor: schoolOrange.withOpacity(0.2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  gradient: isSelected 
                                    ? const LinearGradient(
                                        colors: [schoolOrange, Color(0xFFF16529)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                  color: isSelected ? null : schoolBlue.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isSelected 
                                    ? [BoxShadow(color: schoolOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                                    : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white.withOpacity(0.9) : schoolBlue.withOpacity(0.35),
                                      ),
                                      child: Text(DateFormat('EE').format(date).toUpperCase()),
                                    ),
                                    const SizedBox(height: 2),
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : schoolBlue,
                                      ),
                                      child: Text(date.day.toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // ENTRIES LIST
          Expanded(
            child: Stack(
              children: [
                _showAssignments 
                  ? (studentProvider.diaryEntries.where((e) => e.homework.isNotEmpty).isEmpty 
                      ? _buildEmptyState('Great Job!', 'No pending assignments. You\'re all caught up.')
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          physics: const BouncingScrollPhysics(),
                          itemCount: studentProvider.diaryEntries.where((e) => e.homework.isNotEmpty).length,
                          itemBuilder: (context, index) {
                            final entries = studentProvider.diaryEntries.where((e) => e.homework.isNotEmpty).toList();
                            final entry = entries[index];
                            return _buildAssignmentCard(entry, schoolOrange, schoolBlue);
                          },
                        ))
                  : (() {
                      final filteredEntries = studentProvider.diaryEntries.where((e) => 
                        DateUtils.isSameDay(e.date, _selectedDate)
                      ).toList();

                      if (filteredEntries.isEmpty) {
                        return _buildEmptyState(
                          'A Day of Discovery', 
                          'No entries for ${DateFormat('dd MMM').format(_selectedDate)}. Every lesson is a step toward your future dreams!'
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredEntries.length,
                        itemBuilder: (context, index) {
                          final item = filteredEntries[index];
                          return _buildPremiumDiaryCard(item, schoolOrange, schoolBlue);
                        },
                      );
                    })(),
                if (studentProvider.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.6),
                      child: const Center(
                        child: CircularProgressIndicator(color: schoolOrange, strokeWidth: 3),
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

  Widget _buildAssignmentCard(DiaryEntry task, Color orange, Color navy) {
    bool isCompleted = false; // logic for completion can be added later
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
                    color: navy.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    task.subject.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: navy.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22)
                else if (daysLeft <= 2 && daysLeft >= 0)
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
              task.topic,
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
                fontSize: 13,
                color: navy.withOpacity(0.5),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 16, color: orange.withOpacity(0.8)),
                const SizedBox(width: 8),
                Text(
                  'Due: ${DateFormat('dd MMM').format(task.date)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navy.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: orange,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    children: [
                       Text(
                        isCompleted ? 'View Result' : 'View Details',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumDiaryCard(DiaryEntry item, Color orange, Color navy) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [orange, orange.withOpacity(0.6)],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.subject.toUpperCase(),
                              style: GoogleFonts.inter(
                                color: orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.topic,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Today we covered the fundamentals and practical applications.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: navy.withOpacity(0.5),
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
                              child: Icon(Icons.edit_note_rounded, color: orange, size: 22),
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
                                      color: navy.withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    item.homework,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: orange,
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

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF131742).withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.history_edu_rounded,
                size: 80,
                color: const Color(0xFF131742).withOpacity(0.1),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131742),
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
                color: const Color(0xFF131742).withOpacity(0.4),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const bgLight = Color(0xFFF8F9FE);

class StudentProfileTab extends StatelessWidget {
  const StudentProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final selectedSchoolId = authProvider.selectedSchoolId;

    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

    final themeColor = const Color(0xFFE28743);
    final darkNavy = const Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [themeColor, themeColor.withAlpha(200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Profile',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 40), // Placeholder to keep title centered
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: themeColor.withAlpha(40),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${user?.name ?? "User"}&background=${themeColor.value.toRadixString(16).substring(2).padLeft(6, "0")}&color=fff'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            Text(
              user?.name ?? 'Student Name',
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: darkNavy,
              ),
            ),
            Text(
              user?.email ?? 'student@school.com',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatItem('Grade', '${user?.grade ?? "N/A"} - ${user?.section ?? ""}', themeColor),
                  _buildStatItem('Rank', '12th', themeColor),
                  _buildStatItem('Progress', '92%', themeColor),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Academic Details'),
                  _buildInfoTile(Icons.school_rounded, 'School', school.name, themeColor),
                  _buildInfoTile(Icons.badge_rounded, 'Portal ID', user?.uid.substring(0, 8).toUpperCase() ?? 'N/A', themeColor),
                  _buildInfoTile(Icons.category_rounded, 'Institutional Role', 'Student Apprentice', themeColor),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Personal Settings'),
                  _buildActionTile(Icons.lock_reset_rounded, 'Security Settings', themeColor, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Security settings coming soon')),
                    );
                  }),
                  _buildActionTile(Icons.notifications_none_rounded, 'Notification Preferences', themeColor, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification preferences coming soon')),
                    );
                  }),
                  
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => AuthWrapper()),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.red.withAlpha(51)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'LOGOUT SYSTEM',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color themeColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF131742),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFF131742),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, Color themeColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF131742),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final Color themeColor;
  const _NotificationBadge({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<StudentProvider>().unreadNotificationCount;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(Icons.notifications_outlined, color: themeColor, size: 22),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  unreadCount.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131742), // Restored Visibility
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800, // Restored Visibility
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade500, // Restored Visibility
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3), // Further reduced padding to maximize icon size
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 15,
                    height: 1.2,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

