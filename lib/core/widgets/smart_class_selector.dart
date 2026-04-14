import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:provider/provider.dart';

class SmartClassSelector extends StatefulWidget {
  final ClassModel? initialClass;
  final Function(ClassModel?) onClassSelected;
  final Color themeColor;
  final bool showAllOption;

  const SmartClassSelector({
    super.key,
    this.initialClass,
    required this.onClassSelected,
    required this.themeColor,
    this.showAllOption = false,
  });

  @override
  State<SmartClassSelector> createState() => _SmartClassSelectorState();
}

class _SmartClassSelectorState extends State<SmartClassSelector> {
  String? _selectedGrade;
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    if (widget.initialClass != null) {
      _selectedGrade = widget.initialClass!.name;
      _selectedSection = widget.initialClass!.section;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final grades = provider.availableGrades;
    
    // Add "All" option if needed
    final List<String?> gradeOptions = widget.showAllOption ? [null, ...grades] : grades;

    // Define visibility logic here, BEFORE the Column children list
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final showSection = AttendanceProvider.shouldShowSection(schoolId);

    return Column(
      children: [
        // 1. Grade Selection
        _buildDropdown<String?>(
          label: '1st: Select Grade',
          value: _selectedGrade,
          items: gradeOptions,
          hint: 'Choose Grade...',
          icon: Icons.school_rounded,
          itemLabelBuilder: (grade) => grade ?? 'ALL GRADES (Broadcast)',
          onChanged: (grade) {
            setState(() {
              _selectedGrade = grade;
              _selectedSection = null; // Reset section
            });
            if (grade == null) {
              widget.onClassSelected(null);
            }
          },
        ),
        
        // 2. Section Selection (Only if grade is selected and not "all")
        if (_selectedGrade != null && showSection) ...[
          const SizedBox(height: 12),
          FutureBuilder(
            future: Future.value(provider.getSectionsForGrade(_selectedGrade!)),
            builder: (context, snapshot) {
              final sections = snapshot.data ?? [];
              
              // Automatically pick section if only one exists
              if (sections.length == 1 && _selectedSection == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _selectedSection = sections.first);
                    _notify();
                  }
                });
              }

              return _buildDropdown<String>(
                label: '2nd: Select Section',
                value: _selectedSection,
                items: sections,
                hint: 'Choose Section...',
                icon: Icons.door_front_door_rounded,
                itemLabelBuilder: (sec) => 'Section $sec',
                onChanged: (sec) {
                  setState(() => _selectedSection = sec);
                  _notify();
                },
              );
            },
          ),
        ] else if (_selectedGrade != null && !showSection) ...[
          // Hidden section selection logic for schools that don't want the dropdown
          FutureBuilder(
            future: Future.value(provider.getSectionsForGrade(_selectedGrade!)),
            builder: (context, snapshot) {
              final sections = snapshot.data ?? [];
              if (sections.isNotEmpty && _selectedSection == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _selectedSection = sections.first);
                    _notify();
                  }
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }

  void _notify() {
    if (_selectedGrade != null && _selectedSection != null) {
      final provider = context.read<AttendanceProvider>();
      final cls = provider.getClassByGradeAndSection(_selectedGrade!, _selectedSection!);
      widget.onClassSelected(cls);
    }
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // External label — clean, never overlaps
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.themeColor.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ),
        DropdownButtonFormField<T>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(icon, color: widget.themeColor, size: 22),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: widget.themeColor, width: 1.5),
            ),
          ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade500, size: 22),
            dropdownColor: Colors.white,
            value: value,
            items: items.map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF131742)),
              ),
            )).toList(),
            onChanged: onChanged,
            hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14)),
          ),
      ],
    );
  }
}
