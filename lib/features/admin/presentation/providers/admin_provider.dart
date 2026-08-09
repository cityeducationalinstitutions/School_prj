import 'package:flutter/material.dart';
import 'package:management/features/admin/data/repositories/admin_repository.dart';

class AdminProvider with ChangeNotifier {
  final AdminRepository _repository = AdminRepository();
  
  String _selectedSchoolId = 'all';
  bool _isLoading = false;
  Map<String, int> _dashboardStats = {
    'students': 0,
    'teachers': 0,
    'parents': 0,
    'classes': 0,
  };

  String get selectedSchoolId => _selectedSchoolId;
  bool get isLoading => _isLoading;
  Map<String, int> get dashboardStats => _dashboardStats;

  AdminProvider() {
    refreshDashboard();
  }

  void setSchoolId(String schoolId) {
    if (_selectedSchoolId != schoolId) {
      _selectedSchoolId = schoolId;
      refreshDashboard();
    }
  }

  Future<void> refreshDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboardStats = await _repository.getDashboardStats(_selectedSchoolId);
    } catch (e) {
      debugPrint('Failed to refresh admin dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
