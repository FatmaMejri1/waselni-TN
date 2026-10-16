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

  /// Utilisateur actuellement connecté.
  User? get currentUser => _auth.currentUser;

  /// Écoute les changements de session.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Connexion avec e-mail et mot de passe.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Inscription et création du profil dans Cloud Firestore.
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase did not return a user after registration.');
    }

    final name = displayName.trim();

    await user.updateDisplayName(name);

    final userModel = UserModel(
      id: user.uid,
      displayName: name,
      email: user.email ?? email.trim(),
    );

    await _firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .set(userModel.toMap());

    return credential;
  }

  /// Envoi d'un e-mail de réinitialisation du mot de passe.
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Déconnexion.
  Future<void> signOut() => _auth.signOut();
}
