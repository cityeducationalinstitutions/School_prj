import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/academic_models.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final weekday = now.weekday;
    if (weekday >= 1 && weekday <= 6) {
      _selectedDay = _days[weekday - 1];
    } else {
      _selectedDay = 'Monday';
    }
    Future.microtask(() => context.read<StudentProvider>().fetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final schedules = studentProvider.periods.where((s) => s.day == _selectedDay).toList();
    
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [schoolOrange, schoolOrange.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -40,
                    top: -40,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: schoolBlue.withOpacity(0.06),
                    ),
                  ),
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
                            'DAILY MISSION HUB',
                            style: GoogleFonts.inter(color: schoolBlue, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Class Timetable',
                          style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: schoolBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 16, color: schoolBlue.withOpacity(0.6)),
                            const SizedBox(width: 8),
                            Text(
                              '${schedules.length} Sessions Scheduled',
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

          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverDayHeaderDelegate(
              child: Container(
                height: 80,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    final isSelected = day == _selectedDay;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? schoolOrange : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [BoxShadow(color: schoolOrange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                                : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                            border: Border.all(color: isSelected ? schoolOrange : Colors.grey.shade100, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              day.substring(0, 3).toUpperCase(),
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

          studentProvider.isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: schoolOrange)))
              : schedules.isEmpty
                  ? SliverToBoxAdapter(child: _EmptyEliteView(schoolBlue))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 60),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final entry = schedules[index];
                            final isLast = index == schedules.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      child: _EliteScheduleCard(entry: entry),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: schedules.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

class _EliteScheduleCard extends StatelessWidget {
  final ClassPeriod entry;
  const _EliteScheduleCard({required this.entry});

  DateTime _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      if (isPM && hour < 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  int _getWeekday(String day) {
    switch (day) {
      case 'Monday': return 1;
      case 'Tuesday': return 2;
      case 'Wednesday': return 3;
      case 'Thursday': return 4;
      case 'Friday': return 5;
      case 'Saturday': return 6;
      case 'Sunday': return 7;
      default: return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final entryWeekday = _getWeekday(entry.day);

    bool isLive = false;
    bool isCompleted = false;
    bool isPending = true;

    if (entryWeekday < currentWeekday) {
      isCompleted = true;
      isPending = false;
    } else if (entryWeekday > currentWeekday) {
      isCompleted = false;
      isPending = true;
    } else {
      final start = _parseTime(entry.startTime);
      final end = _parseTime(entry.endTime);
      isLive = now.isAfter(start) && now.isBefore(end);
      isCompleted = now.isAfter(end);
      isPending = now.isBefore(start);
    }

    Color statusColor = schoolBlue.withOpacity(0.4);
    String statusText = 'PENDING';
    if (isLive) {
      statusColor = schoolOrange;
      statusText = 'NOW LIVE';
    } else if (isCompleted) {
      statusColor = Colors.green.shade600;
      statusText = 'COMPLETED';
    }

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isLive 
                  ? schoolOrange.withOpacity(0.08) 
                  : (isCompleted ? Colors.green.withOpacity(0.05) : schoolBlue.withOpacity(0.04)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isCompleted)
                      Icon(Icons.check_circle_outline_rounded, size: 12, color: statusColor.withOpacity(0.6)),
                    if (isPending)
                      Icon(Icons.schedule_rounded, size: 12, color: statusColor.withOpacity(0.4)),
                    if (isCompleted || isPending) const SizedBox(width: 6),
                    Text(
                      isLive ? 'SESSION MISSION' : statusText,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                if (isLive)
                  _LivePulseIndicator(color: schoolOrange),
                if (isCompleted)
                  Text(
                    'Concluded',
                    style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w600, color: statusColor.withOpacity(0.5)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCompleted ? schoolBlue.withOpacity(0.1) : schoolBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        entry.startTime.split(' ')[0],
                        style: GoogleFonts.outfit(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: isCompleted ? schoolBlue.withOpacity(0.6) : Colors.white
                        ),
                      ),
                      Text(
                        entry.startTime.contains(' ') ? entry.startTime.split(' ')[1] : '',
                        style: GoogleFonts.inter(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: isCompleted ? schoolBlue.withOpacity(0.3) : Colors.white.withOpacity(0.5)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.subject,
                        style: GoogleFonts.outfit(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: isCompleted ? schoolBlue.withOpacity(0.4) : schoolBlue
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person_pin_rounded, size: 14, color: isCompleted ? schoolOrange.withOpacity(0.4) : schoolOrange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              entry.teacherName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12, 
                                color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.room_rounded, size: 14, color: isCompleted ? schoolOrange.withOpacity(0.4) : schoolOrange),
                          const SizedBox(width: 6),
                          Text(
                            entry.room ?? 'Main Hall',
                            style: GoogleFonts.inter(
                              fontSize: 12, 
                              color: isCompleted ? Colors.grey.shade300 : Colors.grey.shade500, 
                              fontWeight: FontWeight.w500
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

class _LivePulseIndicator extends StatefulWidget {
  final Color color;
  const _LivePulseIndicator({required this.color});

  @override
  State<_LivePulseIndicator> createState() => _LivePulseIndicatorState();
}

class _LivePulseIndicatorState extends State<_LivePulseIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: widget.color, width: 1),
        ),
        child: Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(
              'NOW LIVE',
              style: TextStyle(color: widget.color, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverDayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverDayHeaderDelegate({required this.child});

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
  bool shouldRebuild(covariant _SliverDayHeaderDelegate oldDelegate) => true;
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
              child: Icon(Icons.event_available_rounded, size: 70, color: navy.withOpacity(0.08)),
            ),
            const SizedBox(height: 32),
            Text(
              'No classes scheduled',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Enjoy your academic break. All daily sessions have been successfully concluded.',
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
