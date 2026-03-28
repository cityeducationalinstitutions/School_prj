import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/features/staff/presentation/providers/material_provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/attendance_models.dart';
import 'package:management/models/material_model.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  ClassModel? _selectedClass;
  final _titleController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchClasses();
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

    final user = context.read<AuthProvider>().currentUser;
    try {
      await context.read<MaterialProvider>().uploadMaterial(
            file: _selectedFile!,
            title: _titleController.text,
            classId: _selectedClass!.id,
            uploadedBy: user?.name ?? 'Staff',
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

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final materialProvider = context.watch<MaterialProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Study Materials')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<ClassModel>(
              decoration: const InputDecoration(labelText: 'Select Class'),
              value: _selectedClass,
              items: attendanceProvider.classes.map((c) {
                return DropdownMenuItem(value: c, child: Text('${c.name} - ${c.section}'));
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedClass = val);
                if (val != null) materialProvider.fetchMaterials(val.id);
              },
            ),
            const SizedBox(height: 24),
            if (_selectedClass != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Resource Title'),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file),
                        label: Text(_selectedFile == null ? 'Select PDF/Doc' : 'File Selected'),
                      ),
                      if (_selectedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_selectedFile!.path.split('/').last, style: const TextStyle(fontSize: 12)),
                        ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: materialProvider.isLoading ? null : _upload,
                        child: materialProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('UPLOAD MATERIAL'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Resources',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (materialProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (materialProvider.materials.isEmpty)
                const Center(child: Text('No materials found for this class.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: materialProvider.materials.length,
                    itemBuilder: (context, index) {
                      final material = materialProvider.materials[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: Text(material.title),
                          subtitle: Text('Uploaded by: ${material.uploadedBy}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () => materialProvider.deleteMaterial(material.id, material.fileUrl, _selectedClass!.id),
                          ),
                          onTap: () {
                            // Logic to open URL in browser or viewer
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
