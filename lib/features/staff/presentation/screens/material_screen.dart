import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/material_provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/models/school_model.dart';
import 'package:management/core/widgets/smart_class_selector.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  ClassModel? _selectedClass;
  final _titleController = TextEditingController();
  File? _selectedFile;
  String _selectedSubject = 'Mathematics';
  final List<String> _subjects = ['Telugu', 'Hindi', 'English', 'Mathematics', 'Physical Science','Biological Science','Chemistry','Social Studies'];

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

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _upload() async {
    if (_selectedClass == null || _selectedFile == null || _titleController.text.isEmpty) return;

    try {
      await context.read<MaterialProvider>().uploadMaterial(
            file: _selectedFile!,
            title: _titleController.text,
            classId: _selectedClass!.id,
            grade: _selectedClass!.name,
            section: _selectedClass!.section,
            subject: _selectedSubject,
          );
      setState(() {
        _selectedFile = null;
        _titleController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  void _renameMaterial(AcademicMaterial material) async {
    final controller = TextEditingController(text: material.title);
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    if (schoolId == null) return;

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Resource'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Title'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text), 
            child: const Text('RENAME'),
          ),
        ],
      ),
    );

    try {
      final messenger = ScaffoldMessenger.of(context);
      if (newTitle != null && newTitle.isNotEmpty && newTitle != material.title) {
        await context.read<MaterialProvider>().updateMaterialTitle(material.id, newTitle, _selectedClass!.name, _selectedClass!.section);
        messenger.showSnackBar(const SnackBar(content: Text('Material renamed!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialProvider = context.watch<MaterialProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Study Materials', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // PREMIUM FILTER CARD
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SmartClassSelector(
                        initialClass: _selectedClass,
                        themeColor: themeColor,
                        onClassSelected: (val) {
                          setState(() => _selectedClass = val);
                          if (val != null) materialProvider.fetchMaterials(val.name, val.section);
                        },
                      ),
                      if (_selectedClass != null) ...[
                        const SizedBox(height: 16),
                        _buildUploadSection(themeColor, materialProvider),
                      ],
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Available Resources',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131742)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          if (_selectedClass == null) 
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('Select a class to view resources'),
            )
          else if (materialProvider.isLoading) 
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (materialProvider.materials.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('No materials found for this class.'),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final material = materialProvider.materials[index];
                    return _buildResourceCard(material, materialProvider, themeColor);
                  },
                  childCount: materialProvider.materials.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildUploadSection(Color themeColor, MaterialProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text('Resource Title', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: themeColor.withOpacity(0.7), letterSpacing: 0.5)),
          ),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.edit_note, color: themeColor),
              hintText: 'Enter title...',
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200, width: 1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200, width: 1)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: themeColor, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdown<String>(
            label: 'Subject',
            value: _selectedSubject,
            items: _subjects,
            hint: 'Select Subject',
            icon: Icons.book_rounded,
            themeColor: themeColor,
            onChanged: (val) => setState(() => _selectedSubject = val!),
          ),
          const SizedBox(height: 16),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedFile == null ? 'Select PDF or Document' : _selectedFile!.path.split('/').last,
                  style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: _pickFile,
                icon: Icon(Icons.attach_file_rounded, color: themeColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _upload,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: provider.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('UPLOAD MATERIAL', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(AcademicMaterial material, MaterialProvider provider, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
        ),
        title: Text(material.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742))),
        subtitle: Text('Subject: ${material.subject}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
              onPressed: () => _renameMaterial(material),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
              onPressed: () => provider.deleteMaterial(material.id, _selectedClass!.name, _selectedClass!.section),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.inter(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required Color themeColor,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabelBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: themeColor.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ),
        DropdownButtonFormField<T>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(icon, color: themeColor, size: 22),
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
              borderSide: BorderSide(color: themeColor, width: 1.5),
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade500, size: 22),
          dropdownColor: Colors.white,
          value: value,
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabelBuilder != null ? itemLabelBuilder(item) : item.toString(),
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
