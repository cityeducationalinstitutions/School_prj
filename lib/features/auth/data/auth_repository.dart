import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await getUserProfile(user.uid);
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, uid);
  }

  Future<UserModel?> signIn(String email, String password, {String? requiredRole}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        final profile = await getUserProfile(credential.user!.uid);
        
        // Role-Based Access Control (RBAC)
        if (requiredRole != null && profile != null) {
          if (!profile.roles.contains(requiredRole)) {
            await _auth.signOut();
            throw Exception('Access Denied: You do not have the required permissions for the $requiredRole role.');
          }
        }
        return profile;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required List<String> roles,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userModel = UserModel(
          uid: credential.user!.uid,
          name: name,
          email: email,
          roles: roles,
        );
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toMap());
        return userModel;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
