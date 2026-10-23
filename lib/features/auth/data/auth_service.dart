import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      try {
        await user.delete();
      } catch (_) {
        try {
          await _auth.signOut();
        } catch (_) {}
      }

      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();

  /// Signs in with a Google ID token obtained by the web Google button.
  Future<UserCredential> signInWithGoogleIdToken(String idToken) async {
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    return _completeGoogleSignIn(credential);
  }

  /// Signs in with Google using the native platform flow.
  /// The web platform must use the official Google sign-in button instead.
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'On the web, use the Google sign-in button to obtain an ID token.',
      );
    }

    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw StateError('Google Sign-In did not return an ID token.');
    }

    return signInWithGoogleIdToken(idToken);
  }

  Future<UserCredential> _completeGoogleSignIn(
    OAuthCredential credential,
  ) async {
    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user == null) {
      throw StateError('Firebase did not return a user after Google sign-in.');
    }

    final userDoc = _firestore.collection(FirestorePaths.users).doc(user.uid);

    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      final userModel = UserModel(
        id: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? '',
      );

      await userDoc.set(userModel.toMap());
    }

    return userCredential;
  }
}
