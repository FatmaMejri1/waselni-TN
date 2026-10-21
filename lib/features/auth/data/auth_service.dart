import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/user_model.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalizedEmail = email.trim();
    final name = displayName.trim();

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase did not return a user after registration.');
    }

    try {
      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        displayName: name,
        email: user.email ?? normalizedEmail,
      );

      await _firestore
          .collection(FirestorePaths.users)
          .doc(user.uid)
          .set(userModel.toMap());

      return credential;
    } catch (_) {
      // Best-effort cleanup if profile creation fails.
      try {
        await user.delete();
      } catch (_) {
        // If deletion fails, avoid leaving the user signed in.
        try {
          await _auth.signOut();
        } catch (_) {
          // Preserve the original registration error.
        }
      }

      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();
}
