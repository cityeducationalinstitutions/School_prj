import 'package:flutter/material.dart';
import 'package:management/features/auth/data/auth_repository.dart';
import 'package:management/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isInitialCheck = true; // For initial app launch
  String? _selectedSchoolId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialCheck => _isInitialCheck;
  String? get selectedSchoolId => _selectedSchoolId;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isInitialCheck = true;
    notifyListeners();
    _currentUser = await _repository.getCurrentUser();
    if (_currentUser != null) {
      _selectedSchoolId = _currentUser!.schoolId;
    }
    _isInitialCheck = false;
    notifyListeners();

    _repository.authStateChanges.listen((user) async {
      if (user == null) {
        _currentUser = null;
        _selectedSchoolId = null;
      } else {
        _currentUser = await _repository.getUserProfile(user.uid);
        _selectedSchoolId = _currentUser?.schoolId;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password, {String? requiredRole, String? schoolId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.signIn(email, password, requiredRole: requiredRole, selectedSchoolId: schoolId);
      _selectedSchoolId = schoolId;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required List<String> roles,
    String? schoolId,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.signUp(
        email: email,
        password: password,
        name: name,
        roles: roles,
        schoolId: schoolId,
      );
      _selectedSchoolId = schoolId;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? schoolId}) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateUserProfile(_currentUser!.uid, {
        if (name != null) 'name': name,
        if (schoolId != null) 'schoolId': schoolId,
      });
      _currentUser = await _repository.getUserProfile(_currentUser!.uid);
      if (schoolId != null) _selectedSchoolId = schoolId;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _currentUser = null;
    _selectedSchoolId = null;
    notifyListeners();
  }
}
