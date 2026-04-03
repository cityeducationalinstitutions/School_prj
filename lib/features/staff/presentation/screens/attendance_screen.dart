import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/school_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedGrade;
  String? _selectedSection;
  ClassModel? _matchingClass;
  String _searchQuery = '';
  
  final Map<String, bool> _attendanceMap = {};
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get _currentSession {
    final now = DateTime.now();
    if (now.hour < 11) return 'Morning';
    if (now.hour >= 12 && now.hour < 15) return 'Evening';
    return 'Locked';
  }

  String get _lockMessage {
    final now = DateTime.now();
    if (now.hour >= 11 && now.hour < 12) return 'Morning session locked at 11:00 AM.\nEvening session opens at 12:00 PM.';
    if (now.hour >= 15) return 'Evening session locked at 3:00 PM.';
    return 'Attendance is currently locked.';
  }

  List<String> get _availableSections {
    if (_selectedGrade == null) return [];
    return context.read<AttendanceProvider>().classes
        .where((c) => c.name == _selectedGrade)
        .map((c) => c.section)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schoolId = context.read<AuthProvider>().selectedSchoolId;
      if (schoolId != null) {
        context.read<AttendanceProvider>().fetchClasses(schoolId);
      }
    });
  }

  void _onGradeChanged(String? val) {
    setState(() {
      _selectedGrade = val;
      _selectedSection = null; // Clear section when grade changes
      _matchingClass = null;
      _attendanceMap.clear();
      _searchQuery = '';
      context.read<AttendanceProvider>().clearExistingRecord();
    });
  }

  void _onSectionChanged(String? val) {
    setState(() {
      _selectedSection = val;
      _attendanceMap.clear();
      _searchQuery = '';
      context.read<AttendanceProvider>().clearExistingRecord();
    });
    
    _findMatchingClass();
  }

  void _findMatchingClass() {
    if (_selectedGrade == null || _selectedSection == null) return;
    
    final provider = context.read<AttendanceProvider>();
    final match = provider.classes.firstWhere(
      (c) => c.name == _selectedGrade && c.section == _selectedSection,
      orElse: () => ClassModel(id: '', name: '', branchId: '', section: ''),
    );

    if (match.id.isNotEmpty) {
      setState(() => _matchingClass = match);
      provider.fetchStudents(match.id).then((_) {
        if (_currentSession != 'Locked') {
          provider.fetchTodayAttendance(match.id, _today, _currentSession).then((_) {
            if (provider.existingRecord != null) {
              for (var student in provider.students) {
                _attendanceMap[student.id] = provider.existingRecord!.studentAttendees[student.id] ?? true;
              }
            } else {
              for (var student in provider.students) {
                _attendanceMap[student.id] = true;
              }
            }
            if (mounted) setState(() {});
          });
        }
      });
    } else {
      setState(() => _matchingClass = null);
    }
  }

  void _saveAttendance() async {
    if (_matchingClass == null) return;

    final attendance = AttendanceModel(
      id: '',
      classId: _matchingClass!.id,
      date: _today,
      sessionType: _currentSession,
      studentAttendees: _attendanceMap,
    );

    try {
      await context.read<AttendanceProvider>().saveAttendance(attendance);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final selectedSchoolId = context.watch<AuthProvider>().selectedSchoolId;
    
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );
    final themeColor = school.themeColor;
    
    final grades = provider.classes.map((c) => c.name).toSet().toList();
    grades.sort((a, b) {
      final numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text(
          'Mark Attendance',
          style: GoogleFonts.inter(
            color: const Color(0xFF131742),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
        actions: [
          if (!provider.isLoading)
            IconButton(
              onPressed: () async {
                await provider.seedInitialData();
                if (context.mounted) {
                  provider.fetchClasses(selectedSchoolId!);
                }
              },
              icon: Icon(Icons.auto_awesome, color: themeColor),
              tooltip: 'Seed All Schools',
            ),
        ],
      ),
      body: Column(
        children: [
          // Date & Selectors Container
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_rounded, color: themeColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_currentSession == "Locked" ? "" : "$_currentSession | "}$_today',
                        style: GoogleFonts.inter(
                          color: themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Fancy Dropdown 1
                _buildDropdown(
                  label: 'Grade',
                  value: _selectedGrade,
                  items: grades,
                  hint: 'Choose Grade (e.g., 1st, 10th)',
                  icon: Icons.school_rounded,
                  themeColor: themeColor,
                  onChanged: _onGradeChanged,
                ),
                
                if (_selectedGrade != null) ...[
                  const SizedBox(height: 16),
                  // Fancy Dropdown 2
                  _buildDropdown(
                    label: 'Section',
                    value: _selectedSection,
                    items: _availableSections,
                    hint: 'Choose Section',
                    icon: Icons.meeting_room_rounded,
                    themeColor: themeColor,
                    onChanged: _onSectionChanged,
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Students List
          Expanded(
            child: _matchingClass != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Students',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF131742),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131742).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${provider.students.length} Total',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF131742),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // SEARCH BAR
                      if (!provider.isLoading && provider.students.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search_rounded, color: themeColor),
                                hintText: 'Search students...',
                                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              style: GoogleFonts.inter(color: const Color(0xFF131742)),
                            ),
                          ),
                        ),
                        
                      Expanded(
                        child: provider.isLoading
                            ? Center(child: CircularProgressIndicator(color: themeColor))
                            : (() {
                                final filteredStudents = provider.students.where((s) {
                                  final q = _searchQuery.toLowerCase();
                                  return s.name.toLowerCase().contains(q) || s.rollNo.toLowerCase().contains(q);
                                }).toList();
                                
                                if (provider.students.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No students found.',
                                      style: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  );
                                }
                                
                                if (filteredStudents.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No students match "$_searchQuery".',
                                      style: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  );
                                }
                                
                                return ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    itemCount: filteredStudents.length,
                                    itemBuilder: (context, index) {
                                      final student = filteredStudents[index];
                                      final isPresent = _attendanceMap[student.id] ?? true;
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.02),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: isPresent 
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.red.withOpacity(0.3),
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                          leading: CircleAvatar(
                                            backgroundColor: isPresent 
                                                ? Colors.green.withOpacity(0.1) 
                                                : Colors.red.withOpacity(0.1),
                                            child: Icon(
                                              isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                              color: isPresent ? Colors.green : Colors.red,
                                            ),
                                          ),
                                          title: Text(
                                            student.name,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF131742),
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Roll No: ${student.rollNo}',
                                            style: GoogleFonts.inter(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          trailing: Switch(
                                            activeColor: Colors.green,
                                            inactiveThumbColor: Colors.red,
                                            inactiveTrackColor: Colors.red.withOpacity(0.3),
                                            value: isPresent,
                                            onChanged: (val) {
                                              setState(() {
                                                _attendanceMap[student.id] = val;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                })(),
                      ),
                    ],
                  )
                : (_selectedGrade != null && _selectedSection != null)
                    ? Center(
                        child: Text(
                          'No matching class found.',
                          style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.checklist_rtl_rounded, size: 64, color: Colors.grey.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text(
                              'Select a Grade and Section\nto start marking attendance',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
          
          // Submit Button
          if (_matchingClass != null && provider.students.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator(color: themeColor))
                    : _currentSession == 'Locked'
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lock_clock_rounded, color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _lockMessage,
                                    style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _saveAttendance,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: themeColor.withOpacity(0.5),
                              ),
                              child: Text(
                                provider.existingRecord != null ? 'EDIT ATTENDANCE' : 'SUBMIT ATTENDANCE',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required Color themeColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: themeColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
        value: value,
        items: items.map((g) => DropdownMenuItem(
          value: g, 
          child: Text(
            g, 
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
          ),
        )).toList(),
        onChanged: onChanged,
        hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400)),
      ),
    );
  }
}
