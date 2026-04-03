import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management/models/staff_activity_models.dart';

class StaffActivityProvider with ChangeNotifier {
  bool _isLoading = false;
  List<StaffAttendanceRecord> _attendanceHistory = [];
  List<LeaveRequest> _leaveRequests = [];
  StaffAttendanceRecord? _todayRecord;
  
  Map<String, double> _leaveBalance = {
    'Sick': 5,
    'Casual': 10,
    'Annual': 15,
  };

  bool get isLoading => _isLoading;
  List<StaffAttendanceRecord> get attendanceHistory => _attendanceHistory;
  List<LeaveRequest> get leaveRequests => _leaveRequests;
  Map<String, double> get leaveBalance => _leaveBalance;
  StaffAttendanceRecord? get todayRecord => _todayRecord;
  bool get isTodayDone => _todayRecord != null && _todayRecord!.checkOut != '--';

  Future<void> fetchActivityData() async {
    _isLoading = true;
    notifyListeners();

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock Attendance History
    _attendanceHistory = [
      StaffAttendanceRecord(date: '2026-04-01', checkIn: '08:45 AM', checkOut: '04:15 PM', status: 'Present', hours: 7.5),
      StaffAttendanceRecord(date: '2026-03-31', checkIn: '08:55 AM', checkOut: '04:05 PM', status: 'Present', hours: 7.2),
      StaffAttendanceRecord(date: '2026-03-30', checkIn: '09:15 AM', checkOut: '04:30 PM', status: 'Late', hours: 7.2),
    ];

    // Mock Leave Requests
    _leaveRequests = [
      LeaveRequest(id: '1', type: 'Sick', startDate: '2026-03-15', endDate: '2026-03-16', status: 'Approved', reason: 'Fever', isHalfDay: false),
      LeaveRequest(id: '2', type: 'Casual', startDate: '2026-02-10', endDate: '2026-02-10', status: 'Approved', reason: 'Personal work', isHalfDay: true, session: 'Morning'),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkIn() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    _todayRecord = StaffAttendanceRecord(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      checkIn: DateFormat('hh:mm AM').format(DateTime.now()),
      checkOut: '--',
      status: 'Present',
      hours: 0,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOut() async {
    if (_todayRecord == null) return;
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    _todayRecord = StaffAttendanceRecord(
      date: _todayRecord!.date,
      checkIn: _todayRecord!.checkIn,
      checkOut: DateFormat('hh:mm PM').format(DateTime.now()),
      status: 'Present',
      hours: 8.0, // Simplified for mock
    );

    // Add to history
    _attendanceHistory.insert(0, _todayRecord!);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> applyForLeave(LeaveRequest request) async {
    _isLoading = true;
    notifyListeners();

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    _leaveRequests.insert(0, request);
    double current = _leaveBalance[request.type] ?? 0;
    _leaveBalance[request.type] = current - (request.isHalfDay ? 0.5 : 1.0);

    _isLoading = false;
    notifyListeners();
  }
}
