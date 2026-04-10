import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/features/student/data/models/student_models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    final filteredNotifications = _selectedCategory == 'All'
        ? studentProvider.notifications
        : studentProvider.notifications.where((n) => n.type.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    // Grouping Logic for filtered list
    final now = DateTime.now();
    final today = filteredNotifications.where((n) => DateUtils.isSameDay(n.createdAt, now)).toList();
    final yesterday = filteredNotifications.where((n) => DateUtils.isSameDay(n.createdAt, now.subtract(const Duration(days: 1)))).toList();
    final earlier = filteredNotifications.where((n) {
      final isToday = DateUtils.isSameDay(n.createdAt, now);
      final isYesterday = DateUtils.isSameDay(n.createdAt, now.subtract(const Duration(days: 1)));
      return !isToday && !isYesterday;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: AppBar(
        title: Text(
          'Notification Center',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: schoolBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: schoolBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (studentProvider.notifications.any((n) => !n.isRead))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: () {
                  for (var n in studentProvider.notifications) {
                    if (!n.isRead) studentProvider.markNotificationRead(n.id);
                  }
                },
                icon: const Icon(Icons.done_all_rounded, size: 16, color: schoolOrange),
                label: Text(
                  'Read All',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: schoolOrange),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // CATEGORY FILTERS
          Container(
            height: 60,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Announcement'),
                _buildFilterChip('Exam'),
                _buildFilterChip('Attendance'),
                _buildFilterChip('Doubt'),
              ],
            ),
          ),

          // LIST VIEW
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEliteEmptyState(schoolBlue)
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      if (today.isNotEmpty) ...[
                        _buildSectionHeader('Today'),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _EliteNotificationCard(notification: today[index]),
                            childCount: today.length,
                          ),
                        ),
                      ],
                      if (yesterday.isNotEmpty) ...[
                        _buildSectionHeader('Yesterday'),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _EliteNotificationCard(notification: yesterday[index]),
                            childCount: yesterday.length,
                          ),
                        ),
                      ],
                      if (earlier.isNotEmpty) ...[
                        _buildSectionHeader('Earlier'),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _EliteNotificationCard(notification: earlier[index]),
                            childCount: earlier.length,
                          ),
                        ),
                      ],
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedCategory == label;
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? schoolBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? schoolBlue : schoolBlue.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: schoolBlue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Center(
          child: Text(
            label == 'Announcement' ? 'Announcements' : 
            label == 'Exam' ? 'Exams' : 
            label == 'Doubt' ? 'Doubts' : label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : schoolBlue.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF131742).withOpacity(0.4),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEliteEmptyState(Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, size: 72, color: navy.withOpacity(0.1)),
          ),
          const SizedBox(height: 32),
          Text(
            'Notification list is empty',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              _selectedCategory == 'All' 
                ? 'No alerts or reminders for your academic journey right now.'
                : 'No notifications found in the $_selectedCategory category.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: navy.withOpacity(0.4),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EliteNotificationCard extends StatelessWidget {
  final AppNotification notification;
  const _EliteNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StudentProvider>();
    final typeData = _getTypeData(notification.type);
    const Color navy = Color(0xFF131742);

    return InkWell(
      onTap: () {
        if (!notification.isRead) provider.markNotificationRead(notification.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : Colors.white,
          border: Border(
            bottom: BorderSide(color: navy.withOpacity(0.03), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Badge
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeData.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(typeData.icon, color: typeData.color, size: 24),
                ),
                if (!notification.isRead)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE28743),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.outfit(
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 16,
                            color: navy,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(notification.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: navy.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: navy.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      notification.type.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: navy.withOpacity(0.35),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return DateFormat('MMM dd').format(date);
  }

  _TypeData _getTypeData(String type) {
    switch (type.toLowerCase()) {
      case 'announcement': return _TypeData(Icons.campaign_rounded, Colors.purple.shade400);
      case 'exam': return _TypeData(Icons.assignment_rounded, Colors.red.shade400);
      case 'attendance': return _TypeData(Icons.calendar_today_rounded, Colors.blue.shade400);
      case 'doubt': return _TypeData(Icons.help_center_rounded, const Color(0xFFE28743));
      default: return _TypeData(Icons.notifications_active_rounded, Colors.teal.shade400);
    }
  }
}

class _TypeData {
  final IconData icon;
  final Color color;
  _TypeData(this.icon, this.color);
}
