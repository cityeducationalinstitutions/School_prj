import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/school_model.dart';
import 'package:management/core/widgets/smart_class_selector.dart';

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
  final String _todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get _currentSession {
    final now = DateTime.now();
    if (now.hour < 12) return 'Morning';
    return 'Evening';
  }

  String get _lockMessage => '';

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

  void _findMatchingClass() {
    if (_matchingClass == null) return;
    
    final provider = context.read<AttendanceProvider>();
    provider.fetchStudents(_matchingClass!.id).then((_) {
      if (_currentSession != 'Locked') {
        provider.fetchTodayAttendance(_matchingClass!.id, DateTime.now(), _currentSession).then((_) {
          if (provider.currentSessionRecords.isNotEmpty) {
            for (var student in provider.students) {
              final record = provider.currentSessionRecords.firstWhere(
                (r) => r.studentId == student.id,
                orElse: () => AttendanceRecord(
                  id: '', 
                  studentId: student.id, 
                  studentName: student.name, 
                  classId: _matchingClass!.id, 
                  date: DateTime.now(), 
                  status: 'Present', 
                  sessionType: _currentSession
                ),
              );
              _attendanceMap[student.id] = record.status == 'Present';
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
  }

  void _saveAttendance() async {
    if (_matchingClass == null) return;

    final records = provider.students.map((student) {
      final now = DateTime.now();
      final normalizedDate = DateTime(now.year, now.month, now.day);
      
      return AttendanceRecord(
        id: '',
        studentId: student.id,
        studentName: student.name,
        classId: _matchingClass!.id,
        date: normalizedDate,
        status: (_attendanceMap[student.id] ?? true) ? 'Present' : 'Absent',
        sessionType: _currentSession,
      );
    }).toList();

    try {
      await context.read<AttendanceProvider>().submitAttendance(records);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  AttendanceProvider get provider => context.read<AttendanceProvider>();

  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<AttendanceProvider>();
    final selectedSchoolId = context.watch<AuthProvider>().selectedSchoolId;
    
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == selectedSchoolId,
      orElse: () => SchoolModel.schools.first,
    );
    final themeColor = school.themeColor;
    
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
          if (!watchProvider.isLoading)
            IconButton(
              onPressed: () async {
                await watchProvider.seedInitialData();
                if (context.mounted) {
                  watchProvider.fetchClasses(selectedSchoolId!);
                }
              },
              icon: Icon(Icons.auto_awesome, color: themeColor),
              tooltip: 'Seed All Schools',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        '${_currentSession == "Locked" ? "" : "$_currentSession | "}$_todayString',
                        style: GoogleFonts.inter(
                          color: themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                SmartClassSelector(
                  initialClass: _matchingClass,
                  themeColor: themeColor,
                  onClassSelected: (cls) {
                    setState(() {
                      _matchingClass = cls;
                      if (cls != null) {
                        _selectedGrade = cls.name;
                        _selectedSection = cls.section;
                      } else {
                        _selectedGrade = null;
                        _selectedSection = null;
                      }
                      _attendanceMap.clear();
                      _searchQuery = '';
                      context.read<AttendanceProvider>().clearCurrentSessionRecords();
                    });
                    if (cls != null) _findMatchingClass();
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
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
                                '${watchProvider.students.length} Total',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF131742),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (!watchProvider.isLoading && watchProvider.students.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.search_rounded, color: themeColor),
                              hintText: 'Search students...',
                              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: themeColor, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            style: GoogleFonts.inter(color: const Color(0xFF131742)),
                          ),
                        ),
                        
                      Expanded(
                        child: watchProvider.isLoading
                            ? Center(child: CircularProgressIndicator(color: themeColor))
                            : (() {
                                final filteredStudents = watchProvider.students.where((s) {
                                  final q = _searchQuery.toLowerCase();
                                  return s.name.toLowerCase().contains(q) || s.rollNo.toLowerCase().contains(q);
                                }).toList();
                                
                                if (watchProvider.students.isEmpty) {
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
                              AttendanceProvider.shouldShowSection(selectedSchoolId)
                                  ? 'Select a Grade and Section\nto start marking attendance'
                                  : 'Select a Grade to start marking attendance',
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
          
          if (_matchingClass != null && watchProvider.students.isNotEmpty)
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
                child: watchProvider.isLoading
                    ? Center(child: CircularProgressIndicator(color: themeColor))
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
                                watchProvider.currentSessionRecords.isNotEmpty ? 'EDIT ATTENDANCE' : 'SUBMIT ATTENDANCE',
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
}
