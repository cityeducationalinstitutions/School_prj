import 'package:cloud_firestore/cloud_firestore.dart';

class FeeItem {
  final String title;
  final double amount;

  FeeItem({required this.title, required this.amount});

  factory FeeItem.fromMap(Map<String, dynamic> map) {
    return FeeItem(
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
    };
  }
}

class FeePayment {
  final String receiptNo;
  final double amount;
  final DateTime date;
  final String mode; // e.g. Online, Cash, Bank Transfer

  FeePayment({
    required this.receiptNo,
    required this.amount,
    required this.date,
    required this.mode,
  });

  factory FeePayment.fromMap(Map<String, dynamic> map) {
    return FeePayment(
      receiptNo: map['receiptNo'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mode: map['mode'] ?? 'Online',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiptNo': receiptNo,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'mode': mode,
    };
  }
}

class FeeRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String grade;
  final String section;
  final double totalFee;
  final double paidAmount;
  final DateTime dueDate;
  final String academicYear;
  final List<FeeItem> breakdown;
  final List<FeePayment> paymentHistory;

  FeeRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.section,
    required this.totalFee,
    required this.paidAmount,
    required this.dueDate,
    required this.academicYear,
    required this.breakdown,
    required this.paymentHistory,
  });

  double get remainingAmount => (totalFee - paidAmount).clamp(0, totalFee);

  String get status {
    if (remainingAmount <= 0) return 'Paid';
    if (paidAmount > 0) {
      if (DateTime.now().isAfter(dueDate)) return 'Overdue';
      return 'Partial';
    }
    if (DateTime.now().isAfter(dueDate)) return 'Overdue';
    return 'Pending';
  }

  factory FeeRecord.fromMap(Map<String, dynamic> map, String id) {
    return FeeRecord(
      id: id,
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      totalFee: (map['totalFee'] ?? 0).toDouble(),
      paidAmount: (map['paidAmount'] ?? 0).toDouble(),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      academicYear: map['academicYear'] ?? '2025-2026',
      breakdown: (map['breakdown'] as List<dynamic>?)
              ?.map((item) => FeeItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      paymentHistory: (map['paymentHistory'] as List<dynamic>?)
              ?.map((item) => FeePayment.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'grade': grade,
      'section': section,
      'totalFee': totalFee,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'dueDate': Timestamp.fromDate(dueDate),
      'academicYear': academicYear,
      'breakdown': breakdown.map((e) => e.toMap()).toList(),
      'paymentHistory': paymentHistory.map((e) => e.toMap()).toList(),
    };
  }
}
