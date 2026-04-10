import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';

class RaiseDoubtScreen extends StatefulWidget {
  const RaiseDoubtScreen({super.key});

  @override
  State<RaiseDoubtScreen> createState() => _RaiseDoubtScreenState();
}

class _RaiseDoubtScreenState extends State<RaiseDoubtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedSubject;
  File? _attachment;
  
  final List<String> _subjects = [
    'Mathematics', 'Physics', 'Chemistry', 'Biology', 
    'English', 'Hindi', 'Social Studies', 'Computer Science'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachment = File(result.files.single.path!);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields', style: TextStyle(color: Colors.white))),
      );
      return;
    }

    try {
      await context.read<StudentProvider>().submitDoubt(
        _selectedSubject!,
        _titleController.text,
        _descriptionController.text,
        attachment: _attachment,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your inquiry has been submitted to the academic board.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<StudentProvider>().isLoading;
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: AppBar(
        title: Text('Raise an Inquiry', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: schoolBlue)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: schoolBlue, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect with your teachers to clarify concepts and deepen your understanding.',
                style: GoogleFonts.inter(color: schoolBlue.withOpacity(0.5), fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 32),

              // Subject Dropdown
              _buildLabel('SUBJECT CONTEXT'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                style: GoogleFonts.inter(color: schoolBlue, fontWeight: FontWeight.w600),
                decoration: _inputDecoration('Choose your subject', Icons.category_outlined),
                items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSubject = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 28),

              // Title
              _buildLabel('INQUIRY TITLE'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.inter(color: schoolBlue, fontWeight: FontWeight.w600),
                decoration: _inputDecoration('e.g., Confusion with Wave Optics', Icons.title_rounded),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 28),

              // Description
              _buildLabel('DETAILED DESCRIPTION'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                style: GoogleFonts.inter(color: schoolBlue, fontSize: 15, height: 1.5),
                decoration: _inputDecoration('Provide context or a specific question...', Icons.description_outlined),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 28),

              // Attachment
              _buildLabel('RESOURCE ATTACHMENT (OPTIONAL)'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickAttachment,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: schoolOrange.withOpacity(0.15), 
                      width: 2, 
                      style: _attachment == null ? BorderStyle.solid : BorderStyle.none
                    ),
                  ),
                  child: _attachment == null
                    ? Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, color: schoolOrange, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to upload screenshot',
                            style: GoogleFonts.outfit(color: schoolOrange, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'JPG, PNG format only',
                            style: GoogleFonts.inter(color: schoolBlue.withOpacity(0.3), fontSize: 12),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_attachment!, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Image Selected', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: schoolBlue)),
                                Text('File ready for upload', style: GoogleFonts.inter(fontSize: 12, color: Colors.green.shade600, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                            onPressed: () => setState(() => _attachment = null),
                          ),
                        ],
                      ),
                ),
              ),
              
              const SizedBox(height: 50),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: schoolOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    shadowColor: schoolOrange.withOpacity(0.5),
                  ),
                  onPressed: isLoading ? null : _submit,
                  child: isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('SUBMIT INQUIRY', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 11, color: const Color(0xFF131742).withOpacity(0.4), letterSpacing: 1.5),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF131742).withOpacity(0.2), size: 20),
      hintStyle: GoogleFonts.inter(color: const Color(0xFF131742).withOpacity(0.25), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFE28743), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      errorStyle: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}
