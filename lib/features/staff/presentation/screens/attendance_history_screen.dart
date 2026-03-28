import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:management/features/staff/presentation/providers/attendance_provider.dart';
import 'package:management/models/attendance_models.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  ClassModel? _selectedClass;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchClasses();
    });
  }

  void _onClassSelected(ClassModel? value) {
    setState(() {
      _selectedClass = value;
    });
    if (value != null) {
      context.read<AttendanceProvider>().fetchHistory(value.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<ClassModel>(
              decoration: const InputDecoration(labelText: 'Select Class'),
              value: _selectedClass,
              items: provider.classes.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text('${c.name} - ${c.section}'),
                );
              }).toList(),
              onChanged: _onClassSelected,
            ),
            const SizedBox(height: 24),
            if (_selectedClass != null) ...[
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.history.isEmpty)
                const Center(child: Text('No history found.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.history.length,
                    itemBuilder: (context, index) {
                      final record = provider.history[index];
                      final presentCount = record.studentAttendees.values.where((v) => v).length;
                      final totalCount = record.studentAttendees.length;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            record.date,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Present: $presentCount / Total: $totalCount'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Detailed view could be added here
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
