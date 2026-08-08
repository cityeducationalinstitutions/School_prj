import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<UserModel?> signIn(String email, String password, {String? requiredRole, String? selectedSchoolId}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        final profile = await getUserProfile(credential.user!.uid);
        
        // Step 1: Verification for selected role
        if (requiredRole != null && profile != null) {
          if (!profile.roles.contains(requiredRole)) {
            await _auth.signOut();
            throw Exception('Access Denied: You do not have the required permissions for the $requiredRole role.');
          }
        }

        // Step 2: Verification for selected school (Multi-Tenancy)
        if (selectedSchoolId != null && profile != null) {
          if (profile.schoolId != null && profile.schoolId != selectedSchoolId) {
            await _auth.signOut();
            throw Exception('Access Denied: This account is registered for another school.');
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
    String? schoolId,
    String? classId,
    String? grade,
    String? section,
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
          schoolId: schoolId,
          classId: classId,
          grade: grade,
          section: section,
        );
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toMap())
            .timeout(const Duration(seconds: 10));
        return userModel;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<String> uploadProfilePicture(String uid, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('users').child(uid).child('profile_image.jpg');
      final bytes = await file.readAsBytes();
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(bytes, metadata);
      final downloadUrl = await ref.getDownloadURL();
      await updateUserProfile(uid, {'profileImageUrl': downloadUrl});
      return downloadUrl;
    } catch (e) {
      // Fallback for Windows Desktop since firebase_storage is not fully supported
      final bytes = await file.readAsBytes();
      final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      await updateUserProfile(uid, {'profileImageUrl': base64String});
      return base64String;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
