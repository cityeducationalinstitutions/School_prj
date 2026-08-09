import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/admin/presentation/providers/admin_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/admin/presentation/widgets/admin_charts.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFE28743)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131742),
                ),
              ),
              const SizedBox(height: 24),
              
              // Stat Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 2 : 1);
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    children: [
                      _buildStatCard('Total Students', provider.dashboardStats['students'].toString(), Icons.school_rounded, Colors.blue),
                      _buildStatCard('Total Teachers', provider.dashboardStats['teachers'].toString(), Icons.badge_rounded, Colors.orange),
                      _buildStatCard('Total Parents', provider.dashboardStats['parents'].toString(), Icons.family_restroom_rounded, Colors.green),
                      _buildStatCard('Total Classes', provider.dashboardStats['classes'].toString(), Icons.class_rounded, Colors.purple),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
              
              // Charts Section
              LayoutBuilder(
                builder: (context, chartConstraints) {
                  bool isWide = chartConstraints.maxWidth > 900;
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isWide ? 2 : 1,
                            child: _buildChartCard(
                              title: 'Student Enrollment Trend',
                              chart: const SizedBox(
                                height: 300,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0, top: 16.0),
                                  child: EnrollmentLineChart(),
                                ),
                              ),
                            ),
                          ),
                          if (isWide) const SizedBox(width: 16),
                          if (isWide)
                            Expanded(
                              flex: 1,
                              child: _buildChartCard(
                                title: 'Today\'s Attendance Overview',
                                chart: const SizedBox(
                                  height: 300,
                                  child: AttendancePieChart(),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (!isWide) ...[
                        const SizedBox(height: 16),
                        _buildChartCard(
                          title: 'Today\'s Attendance Overview',
                          chart: const SizedBox(
                            height: 300,
                            child: AttendancePieChart(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChartCard(
                              title: 'Fee Status (Collected vs Pending vs Overdue)',
                              chart: const SizedBox(
                                height: 300,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: FeesBarChart(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF131742),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget chart}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131742),
            ),
          ),
          const SizedBox(height: 24),
          chart,
        ],
      ),
    );
  }
}
