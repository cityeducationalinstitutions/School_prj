import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnrollmentLineChart extends StatelessWidget {
  const EnrollmentLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.15),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(months[value.toInt()], style: GoogleFonts.inter(fontSize: 10, color: Colors.grey));
                }
                return const Text('');
              },
              reservedSize: 22,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                );
              },
              reservedSize: 28,
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
            left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 100),
              FlSpot(2, 120),
              FlSpot(4, 150),
              FlSpot(6, 210),
              FlSpot(8, 250),
              FlSpot(10, 310),
            ],
            isCurved: true,
            color: const Color(0xFF131742),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF131742).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendancePieChart extends StatelessWidget {
  const AttendancePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: 85,
            title: '85%',
            radius: 50,
            titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: 10,
            title: '10%',
            radius: 50,
            titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: 5,
            title: '5%',
            radius: 50,
            titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class FeesBarChart extends StatelessWidget {
  const FeesBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.15),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
            left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  return Text('₹${(value / 1000).toStringAsFixed(0)}k', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey));
                }
                return Text('₹${value.toInt()}', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey));
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Collected', 'Pending', 'Overdue'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(labels[value.toInt()], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF131742))),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 750000, color: Colors.green, width: 22, borderRadius: BorderRadius.circular(4)),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 200000, color: Colors.orange, width: 22, borderRadius: BorderRadius.circular(4)),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 50000, color: Colors.red, width: 22, borderRadius: BorderRadius.circular(4)),
            ],
          ),
        ],
      ),
    );
  }
}
