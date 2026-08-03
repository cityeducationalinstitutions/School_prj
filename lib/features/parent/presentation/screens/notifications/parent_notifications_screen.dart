import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:management/features/parent/presentation/providers/parent_provider.dart';
import 'package:management/models/academic_models.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final notifications = parentProvider.notifications;

    final filteredList = notifications.where((n) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Fee Dues') return n.type == 'fee';
      if (_selectedFilter == 'Attendance') return n.type == 'attendance';
      if (_selectedFilter == 'Announcements') return n.type == 'announcement';
      return true;
    }).toList();

    const Color primaryNavy = Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Notification Center',
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
      body: Column(
        children: [
          // FILTER CHIPS BAR
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Fee Dues', 'Attendance', 'Announcements'].map((filter) {
                  final bool isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                      selectedColor: primaryNavy,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Text(
                      'No notifications in this category.',
                      style: GoogleFonts.inter(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final notif = filteredList[index];
                      return _buildNotificationTile(context, notif, parentProvider, primaryNavy);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    AppNotification notif,
    ParentProvider provider,
    Color primaryNavy,
  ) {
    IconData iconData = Icons.notifications_rounded;
    Color iconColor = primaryNavy;

    if (notif.type == 'fee') {
      iconData = Icons.account_balance_wallet_rounded;
      iconColor = Colors.orange.shade800;
    } else if (notif.type == 'attendance') {
      iconData = Icons.cancel_rounded;
      iconColor = Colors.red.shade700;
    } else if (notif.type == 'announcement') {
      iconData = Icons.campaign_rounded;
      iconColor = const Color(0xFFE28743);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: notif.isRead ? Colors.grey.shade200 : Colors.amber.shade300,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        title: Text(
          notif.title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
            color: primaryNavy,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${notif.message}\n${DateFormat('dd MMM yyyy, hh:mm a').format(notif.createdAt)}',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
          ),
        ),
        onTap: () => provider.markNotificationRead(notif.id),
      ),
    );
  }
}
