import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/models/school_model.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/features/staff/data/attendance_repository.dart';
import 'package:management/main.dart';

class SignupScreen extends StatefulWidget {
  final String? defaultSchoolId;
  final String? schoolName;
  final String? requiredRole;

  const SignupScreen({
    super.key, 
    this.defaultSchoolId, 
    this.schoolName,
    this.requiredRole,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Enrollment State
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  List<ClassModel> _availableClasses = [];
  ClassModel? _selectedFullClass;
  bool _isLoadingClasses = false;

  @override
  void initState() {
    super.initState();
    if (widget.requiredRole == 'student' && widget.defaultSchoolId != null) {
      _fetchClasses();
    }
  }

  Future<void> _fetchClasses() async {
    setState(() => _isLoadingClasses = true);
    try {
      final classes = await _attendanceRepository.getClasses(widget.defaultSchoolId!);
      setState(() {
        _availableClasses = classes;
        // Sort classes logically (Grade then Section)
        _availableClasses.sort((a, b) {
          final numA = int.tryParse(a.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          final numB = int.tryParse(b.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          if (numA != numB) return numA.compareTo(numB);
          return a.section.compareTo(b.section);
        });
      });
    } catch (e) {
      debugPrint('Error fetching classes for signup: $e');
    } finally {
      setState(() => _isLoadingClasses = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (widget.requiredRole == 'student' && _selectedFullClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Grade and Section')),
      );
      return;
    }

    try {
      await context.read<AuthProvider>().signUp(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            roles: [widget.requiredRole ?? 'staff'], 
            schoolId: widget.defaultSchoolId,
            classId: _selectedFullClass?.id,
            grade: _selectedFullClass?.name,
            section: _selectedFullClass?.section,
          );
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final school = SchoolModel.schools.firstWhere(
      (s) => s.id == widget.defaultSchoolId,
      orElse: () => SchoolModel.schools.first, 
    );
    final themeColor = widget.defaultSchoolId != null ? school.themeColor : Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.schoolName != null) ...[
                Center(
                  child: Text(
                    widget.schoolName!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: themeColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Center(
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF131742),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.requiredRole == 'student' 
                      ? 'Enroll in your institutional class.'
                      : 'Join our school management system.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                themeColor: themeColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                themeColor: themeColor,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                themeColor: themeColor,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),

              if (widget.requiredRole == 'student') ...[
                const SizedBox(height: 24),
                Text(
                  'Select Enrollment',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                ),
                const SizedBox(height: 12),
                if (_isLoadingClasses)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ))
                else if (_availableClasses.isEmpty)
                  Text('No classes available for this school.', style: TextStyle(color: Colors.red.shade400, fontSize: 13))
                else
                  _buildClassDropdown(themeColor),
              ],

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: themeColor.withOpacity(0.4),
                  ),
                  onPressed: isLoading ? null : _signup,
                  child: isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : Text(
                          'CREATE ACCOUNT',
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: GoogleFonts.inter(color: Colors.grey.shade600)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: themeColor),
                    child: Text('Log In', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color themeColor,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: themeColor.withOpacity(0.7)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: themeColor, width: 2)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildClassDropdown(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<ClassModel>(
          decoration: const InputDecoration(border: InputBorder.none),
          value: _selectedFullClass,
          hint: Text('Choose Grade & Section', style: GoogleFonts.inter(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          items: _availableClasses.map((c) {
            return DropdownMenuItem(
              value: c,
              child: Text('${c.name} - ${c.section}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedFullClass = val),
        ),
      ),
    );
  }
}

