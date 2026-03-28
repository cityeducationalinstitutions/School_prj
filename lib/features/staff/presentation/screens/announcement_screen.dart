import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/announcement_provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/announcement_model.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _targetRole = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().fetchAnnouncements();
    });
  }

  void _addAnnouncement() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) return;

    final user = context.read<AuthProvider>().currentUser;
    final announcement = AnnouncementModel(
      id: '',
      title: _titleController.text,
      content: _contentController.text,
      targetRole: _targetRole,
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      author: user?.name ?? 'Staff',
    );

    try {
      await context.read<AnnouncementProvider>().addAnnouncement(announcement);
      _titleController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement posted!')),
      );
      context.read<AnnouncementProvider>().fetchAnnouncements();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(labelText: 'Content'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Target Audience'),
                      value: _targetRole,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Everyone')),
                        DropdownMenuItem(value: 'staff', child: Text('Staff Only')),
                        DropdownMenuItem(value: 'student', child: Text('Students Only')),
                      ],
                      onChanged: (val) => setState(() => _targetRole = val!),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.isLoading ? null : _addAnnouncement,
                      child: const Text('POST ANNOUNCEMENT'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Notices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.announcements.isEmpty)
              const Center(child: Text('No announcements found.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = provider.announcements[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${announcement.content}\n\nBy: ${announcement.author} • ${announcement.date}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
