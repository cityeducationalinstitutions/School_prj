
class StaffAttendanceRecord {
  final String date;
  final String checkIn;
  final String checkOut;
  final String status; // Present, Late, Half-day
  final double hours;

  StaffAttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.hours,
  });
}

class LeaveRequest {
  final String id;
  final String type; // Sick, Casual, Annual
  final String startDate;
  final String endDate;
  final String status; // Pending, Approved, Rejected
  final String reason;
  final bool isHalfDay;
  final String? session; // Morning, Afternoon (for half-day only)

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    this.isHalfDay = false,
    this.session,
  });
}
