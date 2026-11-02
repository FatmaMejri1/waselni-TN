import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:waselni/core/constants/firestore_paths.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/features/auth/domain/user_model.dart';

void main() {
  group('userProfileProvider', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProviderContainer container;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();

      container = ProviderContainer(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<UserModel?> listenForUser(String userId) {
      final completer = Completer<UserModel?>();

      container.listen(userProfileProvider(userId), (previous, next) {
        if (next.hasValue && !completer.isCompleted) {
          completer.complete(next.value);
        }

        if (next.hasError && !completer.isCompleted) {
          completer.completeError(next.error!, next.stackTrace!);
        }
      }, fireImmediately: true);

      return completer.future;
    }

    test('returns UserModel when user profile exists', () async {
      const userId = 'user-123';

      await fakeFirestore.collection(FirestorePaths.users).doc(userId).set({
        'id': userId,
        'displayName': 'Test User',
        'email': 'test@example.com',
        'role': 'passenger',
        'reputation': 5,
        'isActive': true,
      });

      final user = await listenForUser(userId);

      expect(user, isA<UserModel>());
      expect(user?.id, userId);
      expect(user?.displayName, 'Test User');
      expect(user?.email, 'test@example.com');
      expect(user?.role, UserRole.passenger);
      expect(user?.reputation, 5);
      expect(user?.isActive, isTrue);
    });

    test('returns null when user profile does not exist', () async {
      const userId = 'missing-user';

      final user = await listenForUser(userId);

      expect(user, isNull);
    });

    test('uses default values for optional profile fields', () async {
      const userId = 'user-defaults';

      await fakeFirestore.collection(FirestorePaths.users).doc(userId).set({
        'id': userId,
        'role': 'passenger',
      });

      final user = await listenForUser(userId);

      expect(user, isNotNull);
      expect(user?.displayName, '');
      expect(user?.email, '');
      expect(user?.reputation, 0);
      expect(user?.isActive, isTrue);
    });
  });
}
