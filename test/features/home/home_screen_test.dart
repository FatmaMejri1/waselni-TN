import 'package:waselni/features/auth/domain/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/core/router/app_router.dart';
import 'package:waselni/features/home/presentation/home_screen.dart';
import 'package:waselni/features/transport/presentation/transport_stations_screen.dart';
import 'package:waselni/l10n/app_localizations.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  Future<void> pumpHomeScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          currentUserProvider.overrideWith(
            (ref) => const AsyncData<UserModel?>(null),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: const HomeScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('HomeScreen navigation', () {
    testWidgets('opens TransportStationsScreen when Stations is tapped', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      // The Stations card may be below the fold — scroll until it is visible.
      await tester.scrollUntilVisible(
        find.text('Stations de transport'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stations de transport'));
      await tester.pumpAndSettle();

      expect(find.byType(TransportStationsScreen), findsOneWidget);
    });
  });
}
