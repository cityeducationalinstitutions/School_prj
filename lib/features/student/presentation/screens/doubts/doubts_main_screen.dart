import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';
import 'package:management/models/academic_models.dart';
import 'package:management/features/student/presentation/screens/doubts/raise_doubt_screen.dart';
import 'package:management/features/student/presentation/screens/doubts/doubt_detail_screen.dart';

class DoubtsMainScreen extends StatefulWidget {
  const DoubtsMainScreen({super.key});

  @override
  State<DoubtsMainScreen> createState() => _DoubtsMainScreenState();
}

class _DoubtsMainScreenState extends State<DoubtsMainScreen> {
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    final filteredDoubts = _activeFilter == 'all'
        ? studentProvider.doubts
        : studentProvider.doubts.where((d) => d.status == _activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: studentProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: schoolOrange, strokeWidth: 3))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  stretch: true,
                  backgroundColor: schoolBlue,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [schoolOrange, schoolOrange.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -50,
                          top: -20,
                          child: Icon(Icons.quiz_rounded, size: 200, color: Colors.white.withOpacity(0.08)),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                Text(
                                  'Quest for Knowledge',
                                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your inquiries drive academic excellence.',
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    _HeaderStat(label: 'TOTAL', value: studentProvider.doubts.length.toString()),
                                    const SizedBox(width: 32),
                                    _HeaderStat(
                                      label: 'RESOLVED', 
                                      value: studentProvider.doubts.where((d) => d.status == 'resolved').length.toString()
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverFilterDelegate(
                    child: Container(
                      height: 70,
                      color: const Color(0xFFFBFBFE),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _FilterChip(
                            label: 'All Inquiries',
                            isActive: _activeFilter == 'all',
                            onTap: () => setState(() => _activeFilter = 'all'),
                          ),
                          _FilterChip(
                            label: 'Pending',
                            isActive: _activeFilter == 'pending',
                            onTap: () => setState(() => _activeFilter = 'pending'),
                          ),
                          _FilterChip(
                            label: 'In Progress',
                            isActive: _activeFilter == 'in_progress',
                            onTap: () => setState(() => _activeFilter = 'in_progress'),
                          ),
                          _FilterChip(
                            label: 'Resolved',
                            isActive: _activeFilter == 'resolved',
                            onTap: () => setState(() => _activeFilter = 'resolved'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                filteredDoubts.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyEliteState(schoolOrange, schoolBlue),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _EliteDoubtCard(doubt: filteredDoubts[index]),
                            childCount: filteredDoubts.length,
                          ),
                        ),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const RaiseDoubtScreen())
        ),
        backgroundColor: schoolOrange,
        elevation: 10,
        icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
        label: Text('Raise a Doubt', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildEmptyEliteState(Color orange, Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: orange.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology_alt_rounded, size: 80, color: orange.withOpacity(0.2)),
          ),
          const SizedBox(height: 32),
          Text(
            'Clear Minds, Sharp Focus',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'No inquiries found here yet. Feel free to ask your teachers anything to clarify your concepts!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: navy.withOpacity(0.4), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.6), letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color schoolOrange = Color(0xFFE28743);
    const Color schoolBlue = Color(0xFF131742);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? schoolOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? schoolOrange : schoolBlue.withOpacity(0.1)),
          boxShadow: isActive ? [BoxShadow(color: schoolOrange.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14, 
            fontWeight: FontWeight.bold, 
            color: isActive ? Colors.white : schoolBlue.withOpacity(0.6)
          ),
        ),
      ),
    );
  }
}

class _EliteDoubtCard extends StatelessWidget {
  final AcademicDoubt doubt;
  const _EliteDoubtCard({required this.doubt});

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    final statusColor = _getStatusColor(doubt.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: schoolBlue.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoubtDetailScreen(doubt: doubt)),
        ),
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: schoolBlue.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      doubt.subject.toUpperCase(),
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: schoolBlue, letterSpacing: 0.5),
                    ),
                  ),
                  Row(
                    children: [
                      if (doubt.status == 'pending')
                         _PulseIndicator(color: statusColor),
                      const SizedBox(width: 8),
                      Text(
                        doubt.status.toUpperCase().replaceAll('_', ' '),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: 0.8),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                doubt.title,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: schoolBlue),
              ),
              const SizedBox(height: 10),
              Text(
                doubt.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 14, color: schoolBlue.withOpacity(0.5), height: 1.6),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: schoolBlue.withOpacity(0.3)),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM dd, yyyy').format(doubt.createdAt),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: schoolBlue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                  if (doubt.answer != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            'CONSULTED',
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'resolved': return Colors.green.shade400;
      case 'in_progress': return Colors.orange;
      default: return Colors.orange.shade300;
    }
  }
}

class _PulseIndicator extends StatefulWidget {
  final Color color;
  const _PulseIndicator({required this.color});

  @override
  State<_PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<_PulseIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverFilterDelegate({required this.child});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverFilterDelegate oldDelegate) => true;
}
