import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/academic_models.dart';

class ParentDiaryScreen extends StatefulWidget {
  const ParentDiaryScreen({super.key});

  @override
  State<ParentDiaryScreen> createState() => _ParentDiaryScreenState();
}

class _ParentDiaryScreenState extends State<ParentDiaryScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final diaryEntries = parentProvider.diaryEntries;

    // Filter diary entries for selected date or show all recent
    final filteredEntries = diaryEntries.where((e) {
      return e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day;
    }).toList();

    const Color primaryNavy = Color(0xFF131742);
    const Color brandOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Digital Class Diary',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => parentProvider.fetchDiary(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE PICKER STRIP
              _buildDatePickerHeader(context, primaryNavy, brandOrange),
              const SizedBox(height: 24),

              Text(
                'Class Topics & Homework (${DateFormat('dd MMM yyyy').format(_selectedDate)})',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              const SizedBox(height: 14),

              filteredEntries.isEmpty && diaryEntries.isNotEmpty
                  ? _buildDateFilteredNotice(diaryEntries)
                  : filteredEntries.isEmpty
                      ? _buildEmptyDiaryState()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
                            return _buildDiaryCard(entry, primaryNavy, brandOrange);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerHeader(BuildContext context, Color primaryNavy, Color brandOrange) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brandOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event_note_rounded, color: Color(0xFFE28743), size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED DATE',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('EEEE, dd MMM').format(_selectedDate),
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: primaryNavy),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2025, 1, 1),
                lastDate: DateTime(2027, 12, 31),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            icon: const Icon(Icons.calendar_month_rounded, size: 16),
            label: const Text('Change'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryNavy,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryCard(DiaryEntry entry, Color primaryNavy, Color brandOrange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: primaryNavy.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.subject,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(entry.date),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOPIC TAUGHT',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.topic.isNotEmpty ? entry.topic : 'General Classroom Lecture',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.assignment_rounded, color: Color(0xFFE28743), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HOMEWORK ASSIGNED',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900, letterSpacing: 0.8),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              entry.homework.isNotEmpty ? entry.homework : 'No written homework assigned for today.',
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, height: 1.3),
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
        ],
      ),
    );
  }

  Widget _buildDateFilteredNotice(List<DiaryEntry> allEntries) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(Icons.event_busy_rounded, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No Diary Entry for ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Below are the most recent class diary entries:',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allEntries.take(3).length,
          itemBuilder: (context, index) {
            return _buildDiaryCard(allEntries[index], const Color(0xFF131742), const Color(0xFFE28743));
          },
        ),
      ],
    );
  }

  Widget _buildEmptyDiaryState() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          'No diary entries logged yet.',
          style: GoogleFonts.inter(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
