import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/school_model.dart';

class StaffScheduleItem {
  final String time;
  final String endTime;
  final String subject;
  final String className;
  final String room;
  final bool isCurrent;

  StaffScheduleItem({
    required this.time,
    required this.endTime,
    required this.subject,
    required this.className,
    required this.room,
    this.isCurrent = false,
  });
}

class StaffScheduleTab extends StatelessWidget {
  const StaffScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final selectedSchoolId = authProvider.selectedSchoolId;
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );

    final themeColor = school.themeColor;
    final darkNavy = const Color(0xFF131742);

    final List<StaffScheduleItem> schedule = [
      StaffScheduleItem(time: '09:00 AM', endTime: '10:00 AM', subject: 'Mathematics', className: '8th Grade - s1', room: 'Room 102'),
      StaffScheduleItem(time: '10:30 AM', endTime: '11:30 AM', subject: 'Mathematics', className: '10th Grade - Talent', room: 'Lab 1', isCurrent: true),
      StaffScheduleItem(time: '01:00 PM', endTime: '02:00 PM', subject: 'Mathematics', className: '7th Grade - s2', room: 'Room 204'),
      StaffScheduleItem(time: '02:30 PM', endTime: '03:30 PM', subject: 'Mathematics', className: '9th Grade - regular', room: 'Room 301'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // PREMIUM HEADER
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Schedule',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: darkNavy,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, MMMM d').format(DateTime.now()),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.notifications_active_rounded, color: themeColor),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Notifications: Get reminders for your next class and school-wide alerts.'),
                                  backgroundColor: themeColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // PROGRESS BAR
                    _buildProgressGauge(themeColor),
                  ],
                ),
              ),
            ),

            // HORIZONTAL CALENDAR
            SliverToBoxAdapter(
              child: _buildHorizontalCalendar(themeColor),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // TIMELINE LIST
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = schedule[index];
                    final now = DateTime.now();
                    
                    // Simple parsing for mock - in a real app, these would be DateTime objects
                    final startTime = _parseTime(item.time);
                    final endTime = _parseTime(item.endTime);
                    
                    String status = 'PENDING';
                    if (now.isAfter(endTime)) {
                      status = 'COMPLETED';
                    } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
                      status = 'LIVE';
                    }

                    return _buildTimelineItem(item, status, themeColor, darkNavy, index == schedule.length - 1);
                  },
                  childCount: schedule.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseTime(String timeStr) {
    try {
      final now = DateTime.now();
      final format = DateFormat('hh:mm a');
      final time = format.parse(timeStr);
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget _buildProgressGauge(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeColor, themeColor.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeColor.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.white.withAlpha(51),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 6,
                ),
              ),
              const Text(
                '3/5',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, Teacher!',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '60% of your teaching day is completed.',
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha(230),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar(Color themeColor) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 2));
          final isToday = index == 2;
          return Container(
            width: 65,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: isToday ? themeColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isToday 
                ? [BoxShadow(color: themeColor.withAlpha(77), blurRadius: 10, offset: const Offset(0, 5))]
                : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: GoogleFonts.inter(
                    color: isToday ? Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date.day.toString(),
                  style: GoogleFonts.outfit(
                    color: isToday ? Colors.white : const Color(0xFF131742),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(StaffScheduleItem item, String status, Color themeColor, Color darkNavy, bool isLast) {
    final isLive = status == 'LIVE';
    final isCompleted = status == 'COMPLETED';
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TIME COLUMN
          Column(
            children: [
              Text(
                item.time,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isLive ? themeColor : darkNavy,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isLast ? Colors.transparent : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 2,
                      height: isLive ? 50 : (isCompleted ? double.infinity : 0),
                      color: isCompleted ? themeColor.withAlpha(100) : themeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // CARD COLUMN
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: isLive ? Border.all(color: themeColor.withAlpha(128), width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isLive ? 20 : 8),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLive ? themeColor.withAlpha(26) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.subject.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: isLive ? themeColor : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // STATUS BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLive 
                            ? Colors.green.shade50 
                            : (isCompleted ? Colors.blue.shade50 : Colors.orange.shade50),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            color: isLive 
                              ? Colors.green.shade700 
                              : (isCompleted ? Colors.blue.shade700 : Colors.orange.shade700),
                            fontWeight: FontWeight.bold, 
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.className,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isCompleted ? darkNavy.withAlpha(153) : darkNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            item.room,
                            style: GoogleFonts.inter(
                              color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade500, 
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            '${item.time} - ${item.endTime}',
                            style: GoogleFonts.inter(
                              color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade500, 
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
