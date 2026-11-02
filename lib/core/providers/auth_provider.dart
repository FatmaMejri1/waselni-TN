import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_service.dart';
import '../../features/auth/domain/user_model.dart';
import '../constants/firestore_paths.dart';

/// Provides the authentication service.
///
/// Can be overridden in tests with a mock AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Listens to Firebase Authentication state changes.
///
/// Emits:
/// - User when authenticated.
/// - null when signed out.
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provides the Firestore instance.
///
/// Can be overridden in tests with FakeFirebaseFirestore.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Listens to a user's Firestore profile in real time.
final userProfileProvider = StreamProvider.family<UserModel?, String>((
  ref,
  userId,
) {
  return ref
      .watch(firestoreProvider)
      .collection(FirestorePaths.users)
      .doc(userId)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }

        final data = snapshot.data();

        if (data == null) {
          return null;
        }

        return UserModel.fromMap(data);
      });
});

/// Provides the current authenticated user's Firestore profile.
///
/// Returns:
/// - AsyncData(null) when signed out.
/// - AsyncLoading while authentication/profile is loading.
/// - AsyncData(UserModel) when the profile is available.
/// - AsyncError if authentication or profile loading fails.
final currentUserProvider = Provider<AsyncValue<UserModel?>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (firebaseUser) {
      if (firebaseUser == null) {
        return const AsyncData<UserModel?>(null);
      }

      return ref.watch(userProfileProvider(firebaseUser.uid));
    },
    loading: () => const AsyncLoading<UserModel?>(),
    error: (error, stackTrace) {
      return AsyncError<UserModel?>(error, stackTrace);
    },
  );
});

/// Provides the role of the currently authenticated user.
///
/// The role comes from Firestore, not from a value supplied by the UI.
final userRoleProvider = Provider<AsyncValue<UserRole?>>((ref) {
  return ref
      .watch(currentUserProvider)
      .whenData((userProfile) => userProfile?.role);
});
