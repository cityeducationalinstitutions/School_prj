import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/attendance_models.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  DateTime _focusedMonth = DateTime.now();
  final Color schoolBlue = const Color(0xFF131742);
  final Color schoolOrange = const Color(0xFFE28743);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    context.read<StudentProvider>().fetchAttendance(_focusedMonth.month, _focusedMonth.year);
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final attendanceList = studentProvider.monthlyAttendance;
    
    // Calculate metrics
    final totalWorkingDays = attendanceList.length;
    final presentDays = attendanceList.where((a) => a.status.toLowerCase() == 'present').length;
    final presencePercentage = totalWorkingDays > 0 ? (presentDays / totalWorkingDays * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: schoolOrange,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue, size: 20),
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
                    bottom: 20,
                    left: 24,
                    right: 24,
                    child: Column(
                      children: [
                        _AttendanceGauge(percentage: presencePercentage, schoolBlue: schoolBlue),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _EliteMetricCard(label: 'Total Working Days', value: totalWorkingDays.toString(), icon: Icons.calendar_month, color: schoolBlue)),
                            const SizedBox(width: 16),
                            Expanded(child: _EliteMetricCard(label: 'Days Present', value: presentDays.toString(), icon: Icons.check_circle_rounded, color: Colors.green.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
              child: Column(
                children: [
                  _MonthSelector(
                    focusedMonth: _focusedMonth,
                    schoolBlue: schoolBlue,
                    onPrev: () {
                      setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));
                      _fetchData();
                    },
                    onNext: () {
                      setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));
                      _fetchData();
                    },
                  ),
                  const SizedBox(height: 20),
                  _PresenceInsightStrip(schoolBlue: schoolBlue, schoolOrange: schoolOrange),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                          ),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    _buildEliteCalendarGrid(attendanceList),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(label: 'Present', color: Colors.green.shade600, isDot: true),
                        const SizedBox(width: 16),
                        _LegendItem(label: 'Absent', color: Colors.red.shade400, isDot: true),
                        const SizedBox(width: 16),
                        _LegendItem(label: 'Holiday', color: schoolOrange, isDot: true),
                      ],
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

  Widget _buildEliteCalendarGrid(List<AttendanceRecord> attendance) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday % 7;

    final List<Widget> dayWidgets = [];

    for (var i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const Expanded(child: SizedBox()));
    }

    for (var i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final isSunday = date.weekday == DateTime.sunday;
      final isToday = DateUtils.isSameDay(date, DateTime.now());
      
      final record = attendance.cast<AttendanceRecord?>().firstWhere(
        (a) => DateUtils.isSameDay(a?.date, date),
        orElse: () => null,
      );

      final status = record?.status.toLowerCase() ?? (isSunday ? 'holiday' : 'none');
      final isAbsent = status == 'absent';
      final isHoliday = status == 'holiday' || isSunday;
      final isPresent = status == 'present';
      
      dayWidgets.add(
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isAbsent 
                    ? Colors.red.shade50
                    : isHoliday
                        ? schoolOrange.withOpacity(0.08)
                        : isPresent 
                            ? Colors.green.shade50.withOpacity(0.5)
                            : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: isToday ? Border.all(color: schoolOrange, width: 2) : null,
              ),
              child: Center(
                child: Text(
                  i.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isToday || isAbsent || isHoliday || isPresent ? FontWeight.bold : FontWeight.w500,
                    color: isAbsent 
                        ? Colors.red.shade400
                        : isHoliday
                            ? schoolOrange
                            : isPresent
                                ? Colors.green.shade600
                                : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        )
      );
    }

    final List<Widget> rows = [];
    for (var i = 0; i < dayWidgets.length; i += 7) {
      final end = (i + 7 > dayWidgets.length) ? dayWidgets.length : i + 7;
      final rowItems = dayWidgets.sublist(i, end);
      if (rowItems.length < 7) {
        final count = 7 - rowItems.length;
        for (var j = 0; j < count; j++) {
          rowItems.add(const Expanded(child: SizedBox()));
        }
      }
      rows.add(Row(children: rowItems));
    }

    return Column(children: rows);
  }
}

class _AttendanceGauge extends StatelessWidget {
  final int percentage;
  final Color schoolBlue;
  const _AttendanceGauge({required this.percentage, required this.schoolBlue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 10,
              backgroundColor: Colors.grey.shade100,
              color: Colors.green.shade600,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: schoolBlue),
              ),
              Text(
                'Presence',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EliteMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _EliteMetricCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final DateTime focusedMonth;
  final Color schoolBlue;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelector({required this.focusedMonth, required this.schoolBlue, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: onPrev, icon: Icon(Icons.chevron_left_rounded, color: schoolBlue)),
        Text(
          DateFormat('MMMM yyyy').format(focusedMonth),
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: schoolBlue),
        ),
        IconButton(onPressed: onNext, icon: Icon(Icons.chevron_right_rounded, color: schoolBlue)),
      ],
    );
  }
}

class _PresenceInsightStrip extends StatelessWidget {
  final Color schoolBlue;
  final Color schoolOrange;

  const _PresenceInsightStrip({required this.schoolBlue, required this.schoolOrange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: schoolBlue.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _InsightItem(icon: Icons.flash_on_rounded, label: '12 Day Streak', color: schoolOrange),
          const Spacer(),
          Container(width: 1, height: 20, color: schoolBlue.withOpacity(0.1)),
          const Spacer(),
          _InsightItem(icon: Icons.verified_rounded, label: 'Elite Presence', color: Colors.green.shade600),
        ],
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InsightItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDot;

  const _LegendItem({required this.label, required this.color, this.isDot = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: isDot ? BoxShape.circle : BoxShape.rectangle, borderRadius: isDot ? null : BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
