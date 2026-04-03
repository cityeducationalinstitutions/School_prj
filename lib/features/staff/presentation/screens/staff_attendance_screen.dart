import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/staff_activity_provider.dart';

class StaffAttendanceScreen extends StatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StaffActivityProvider>().fetchActivityData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('My Attendance', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF131742),
      ),
      body: Consumer<StaffActivityProvider>(
        builder: (context, provider, child) {
          final today = provider.todayRecord;
          final isDone = provider.isTodayDone;

          return Column(
            children: [
              // ATTENDANCE ACTION CARD
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDone 
                        ? [Colors.green.shade400, Colors.green.shade700]
                        : (today != null 
                            ? [const Color(0xFFE28743), const Color(0xFFC46A2E)]
                            : [const Color(0xFF131742), const Color(0xFF242B6A)]),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (isDone ? Colors.green : const Color(0xFF131742)).withAlpha(60),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isDone ? Icons.check_circle_outline_rounded : Icons.fingerprint_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isDone 
                          ? 'Attendance Completed' 
                          : (today != null ? 'You are Checked In' : 'Ready to Work?'),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isDone 
                          ? 'Great job! See you tomorrow.' 
                          : (today != null 
                              ? 'Checked in at ${today.checkIn}. Don\'t forget to check out!' 
                              : 'Tap the button below to mark your presence.'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: Colors.white.withAlpha(200), fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      if (!isDone)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.isLoading 
                              ? null 
                              : () {
                                  if (today == null) {
                                    provider.checkIn();
                                  } else {
                                    provider.checkOut();
                                  }
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: today != null ? const Color(0xFFE28743) : const Color(0xFF131742),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: provider.isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(
                                  today == null ? 'CHECK IN NOW' : 'CHECK OUT NOW',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // HISTORY SECTION
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Recent History',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF131742),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: provider.isLoading && provider.attendanceHistory.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: provider.attendanceHistory.length,
                              itemBuilder: (context, index) {
                                final record = provider.attendanceHistory[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.shade100),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE28743).withAlpha(20),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.history_toggle_off_rounded, color: Color(0xFFE28743)),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('EEEE, MMM d').format(DateTime.parse(record.date)),
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${record.checkIn} - ${record.checkOut}',
                                              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${record.hours}h',
                                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFFE28743)),
                                          ),
                                          Text(
                                            record.status,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: record.status == 'Present' ? Colors.green : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
