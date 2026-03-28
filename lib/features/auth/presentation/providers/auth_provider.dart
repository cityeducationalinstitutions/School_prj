import 'package:flutter/material.dart';
import 'package:management/features/auth/data/auth_repository.dart';
import 'package:management/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _repository.getCurrentUser();
    _isLoading = false;
    notifyListeners();

    _repository.authStateChanges.listen((user) async {
      if (user == null) {
        _currentUser = null;
      } else {
        _currentUser = await _repository.getUserProfile(user.uid);
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password, {String? requiredRole}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.signIn(email, password, requiredRole: requiredRole);
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
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.signUp(
        email: email,
        password: password,
        name: name,
        roles: roles,
      );
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
    notifyListeners();
  }
}
