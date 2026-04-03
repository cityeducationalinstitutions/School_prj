import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/staff/presentation/providers/announcement_provider.dart';
import 'package:management/features/auth/presentation/providers/auth_provider.dart';
import 'package:management/models/announcement_model.dart';
import 'package:management/models/school_model.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _targetRole = 'all';
  String? _editingId;

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _titleController.clear();
      _contentController.clear();
      _targetRole = 'all';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schoolId = context.read<AuthProvider>().selectedSchoolId;
      if (schoolId != null) {
        context.read<AnnouncementProvider>().fetchAnnouncements(schoolId);
      }
    });
  }

  void _addAnnouncement() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    final schoolId = authProvider.selectedSchoolId;
    final provider = context.read<AnnouncementProvider>();

    if (schoolId == null) return;

    final announcement = AnnouncementModel(
      id: _editingId ?? '',
      title: _titleController.text,
      content: _contentController.text,
      targetRole: _targetRole,
      date: _editingId != null 
          ? provider.announcements.firstWhere((a) => a.id == _editingId).date
          : DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      author: user?.name ?? 'Staff',
      schoolId: schoolId,
    );

    try {
      final messenger = ScaffoldMessenger.of(context);
      if (_editingId != null) {
        await provider.updateAnnouncement(announcement);
        messenger.showSnackBar(
          const SnackBar(content: Text('Announcement updated!')),
        );
      } else {
        await provider.addAnnouncement(announcement);
        messenger.showSnackBar(
          const SnackBar(content: Text('Announcement posted!')),
        );
      }
      
      _cancelEdit();
      if (mounted) {
        provider.fetchAnnouncements(schoolId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _editAnnouncement(AnnouncementModel announcement) {
    setState(() {
      _editingId = announcement.id;
      _titleController.text = announcement.title;
      _contentController.text = announcement.content;
      _targetRole = announcement.targetRole;
    });
  }

  void _deleteAnnouncement(String id) async {
    final authProvider = context.read<AuthProvider>();
    final schoolId = authProvider.selectedSchoolId;
    if (schoolId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Are you sure you want to delete this notice?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await context.read<AnnouncementProvider>().deleteAnnouncement(id, schoolId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement deleted!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();
    final schoolId = context.read<AuthProvider>().selectedSchoolId;
    final school = SchoolModel.schools.firstWhere((s) => s.id == schoolId, orElse: () => SchoolModel.schools.first);
    final themeColor = school.themeColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Broadcast Notice', style: GoogleFonts.inter(color: const Color(0xFF131742), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF131742)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // PREMIUM BROADCAST CARD
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _editingId != null ? 'Edit Official Notice' : 'Create Official Notice', 
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742)),
                          ),
                          if (_editingId != null)
                            TextButton(
                              onPressed: _cancelEdit,
                              child: Text('Cancel', style: TextStyle(color: themeColor)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildFormSection(themeColor, provider),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Broadcasts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131742)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          if (provider.isLoading) 
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (provider.announcements.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState('No official notices found.'),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final announcement = provider.announcements[index];
                    return _buildNoticeCard(announcement, themeColor);
                  },
                  childCount: provider.announcements.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildFormSection(Color themeColor, AnnouncementProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title of Notice',
              labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(Icons.campaign_rounded, color: themeColor),
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Content Details',
              labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              prefixIcon: Icon(Icons.text_fields_rounded, color: themeColor),
              border: InputBorder.none,
            ),
            maxLines: 2,
          ),
          const Divider(),
          _buildDropdown<String>(
            label: 'Target Audience',
            value: _targetRole,
            items: ['all', 'staff', 'student'],
            hint: 'Select Audience',
            icon: Icons.groups_rounded,
            themeColor: themeColor,
            itemLabelBuilder: (val) => val == 'all' ? 'Everyone' : (val == 'staff' ? 'Staff Only' : 'Students Only'),
            onChanged: (val) => setState(() => _targetRole = val!),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _addAnnouncement,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: provider.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_editingId != null ? 'UPDATE BROADCAST' : 'POST BROADCAST', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(AnnouncementModel notice, Color themeColor) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: notice.targetRole == 'staff' ? Colors.purple.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notice.targetRole.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: notice.targetRole == 'staff' ? Colors.purple : Colors.green, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 10
                    ),
                  ),
                ),
                Text(
                  notice.date,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notice.title,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF131742), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              notice.content,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Posted by ${notice.author}',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                      onPressed: () => _editAnnouncement(notice),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                      onPressed: () => _deleteAnnouncement(notice.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
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
          Icon(Icons.mark_email_unread_rounded, size: 64, color: Colors.grey.shade300),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
          prefixIcon: Icon(icon, color: themeColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
        value: value,
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabelBuilder != null ? itemLabelBuilder(item) : item.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF131742)),
          ),
        )).toList(),
        onChanged: onChanged,
        hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14)),
      ),
    );
  }
}
