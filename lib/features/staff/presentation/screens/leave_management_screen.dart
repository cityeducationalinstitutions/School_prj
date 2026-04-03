import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management/features/staff/presentation/providers/staff_activity_provider.dart';
import 'package:management/models/staff_activity_models.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StaffActivityProvider>().fetchActivityData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffActivityProvider>();
    final themeColor = const Color(0xFFE28743);
    final darkColor = const Color(0xFF131742);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // PREMIUM SLIVER APP BAR
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: darkColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsetsDirectional.only(start: 50, bottom: 16),
              title: Text(
                'Leave Management',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [darkColor, darkColor.withBlue(100)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withAlpha(10),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your Leave Summary',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Track & Apply Leaves',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BALANCE CARDS SECTION
          SliverToBoxAdapter(
            child: Container(
              height: 140,
              margin: const EdgeInsets.only(top: 24, bottom: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: provider.leaveBalance.entries.map((e) {
                  return _buildBalanceCard(e.key, e.value, themeColor);
                }).toList(),
              ),
            ),
          ),

          // HISTORY HEADER
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Leave History',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: GoogleFonts.inter(
                        color: themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // HISTORY LIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: provider.isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : provider.leaveRequests.isEmpty
                    ? const SliverToBoxAdapter(child: Center(child: Text('No leave requests found')))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final request = provider.leaveRequests[index];
                            return _buildRequestCard(request);
                          },
                          childCount: provider.leaveRequests.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showApplyLeaveSheet(context),
        backgroundColor: themeColor,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Apply Leave',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String label, double balance, Color themeColor) {
    IconData icon;
    Color iconColor;
    switch (label) {
      case 'Sick':
        icon = Icons.medical_services_rounded;
        iconColor = Colors.redAccent;
        break;
      case 'Casual':
        icon = Icons.person_rounded;
        iconColor = Colors.blueAccent;
        break;
      default:
        icon = Icons.beach_access_rounded;
        iconColor = Colors.orangeAccent;
    }

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const Spacer(),
          Text(
            balance.toString().replaceAll('.0', ''),
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131742),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(LeaveRequest request) {
    final statusColor = _getStatusColor(request.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                request.type,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color(0xFF131742),
                                ),
                              ),
                              if (request.isHalfDay) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withAlpha(30),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Half Day',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              request.status,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            request.isHalfDay 
                                ? '${request.startDate} (${request.session})'
                                : '${request.startDate} to ${request.endDate}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (request.reason.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          request.reason,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showApplyLeaveSheet(BuildContext context) {
    String selectedType = 'Sick';
    bool isHalfDay = false;
    String selectedSession = 'Morning';
    DateTime startDate = DateTime.now().add(const Duration(days: 1));
    DateTime endDate = DateTime.now().add(const Duration(days: 2));
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Apply for Leave',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF131742),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // LEAVE TYPE
                  _buildLabel('Leave Type'),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    dropdownColor: Colors.white,
                    decoration: _inputDecoration(null),
                    items: ['Sick', 'Casual', 'Annual'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setModalState(() => selectedType = v!),
                  ),
                  const SizedBox(height: 20),

                  // DAY TYPE (FULL/HALF)
                  _buildLabel('Duration'),
                  Row(
                    children: [
                      _buildChoiceChip('Full Day', !isHalfDay, () => setModalState(() => isHalfDay = false)),
                      const SizedBox(width: 12),
                      _buildChoiceChip('Half Day', isHalfDay, () => setModalState(() => isHalfDay = true)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (isHalfDay) ...[
                    _buildLabel('Select Session'),
                    Row(
                      children: [
                        _buildChoiceChip('Morning', selectedSession == 'Morning', () => setModalState(() => selectedSession = 'Morning')),
                        const SizedBox(width: 12),
                        _buildChoiceChip('Afternoon', selectedSession == 'Afternoon', () => setModalState(() => selectedSession = 'Afternoon')),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // DATE PICKER
                  _buildLabel(isHalfDay ? 'Select Date' : 'Select Date Range'),
                  InkWell(
                    onTap: () async {
                      if (isHalfDay) {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setModalState(() => startDate = picked);
                      } else {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setModalState(() {
                            startDate = picked.start;
                            endDate = picked.end;
                          });
                        }
                      }
                    },
                    child: InputDecorator(
                      decoration: _inputDecoration(Icons.calendar_month_rounded),
                      child: Row(
                        children: [
                          Text(
                            isHalfDay 
                                ? DateFormat('MMM dd, yyyy').format(startDate)
                                : '${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit_calendar_rounded, size: 20, color: Color(0xFFE28743)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Reason (Optional)'),
                  TextField(
                    controller: reasonController,
                    maxLines: 2,
                    decoration: _inputDecoration(null).copyWith(hintText: 'Work from home, sickness...'),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        final req = LeaveRequest(
                          id: DateTime.now().toString(),
                          type: selectedType,
                          startDate: DateFormat('yyyy-MM-dd').format(startDate),
                          endDate: isHalfDay ? DateFormat('yyyy-MM-dd').format(startDate) : DateFormat('yyyy-MM-dd').format(endDate),
                          status: 'Pending',
                          reason: reasonController.text,
                          isHalfDay: isHalfDay,
                          session: isHalfDay ? selectedSession : null,
                        );
                        final messenger = ScaffoldMessenger.of(context);
                        context.read<StaffActivityProvider>().applyForLeave(req);
                        Navigator.pop(context);
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('$selectedType leave requested successfully'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF131742),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE28743),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'SUBMIT REQUEST',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE28743) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData? icon) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, size: 20, color: const Color(0xFFE28743)) : null,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[100]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE28743), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
