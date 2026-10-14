import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

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

  /// Inscription avec e-mail, mot de passe et nom.
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(displayName.trim());

    return credential;
  }

  /// Envoi d'un e-mail de réinitialisation du mot de passe.
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Déconnexion.
  Future<void> signOut() => _auth.signOut();
}
