import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/features/transport/domain/station_model.dart';
import 'package:waselni/features/transport/presentation/transport_stations_screen.dart';
import 'package:waselni/l10n/app_localizations.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  Future<void> pumpTransportStationsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: const TransportStationsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('TransportStationsScreen', () {
    testWidgets('displays stations returned by Firestore', (tester) async {
      final now = DateTime(2026, 10, 31);

      final station = StationModel(
        id: 'station-1',
        name: 'Station Centre',
        latitude: 36.8065,
        longitude: 10.1815,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('stations')
          .doc(station.id)
          .set(station.toMap());

      await pumpTransportStationsScreen(tester);

      expect(find.text('Station Centre'), findsOneWidget);
      expect(find.textContaining('36.8065'), findsOneWidget);
      expect(find.textContaining('10.1815'), findsOneWidget);
    });

    testWidgets('displays the empty state when no stations exist', (
      tester,
    ) async {
      await pumpTransportStationsScreen(tester);

      expect(find.text('Aucune station disponible.'), findsOneWidget);
    });

    testWidgets('does not display inactive stations', (tester) async {
      final now = DateTime(2026, 10, 31);

      final inactiveStation = StationModel(
        id: 'station-1',
        name: 'Inactive Station',
        latitude: 36.8065,
        longitude: 10.1815,
        isActive: false,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('stations')
          .doc(inactiveStation.id)
          .set(inactiveStation.toMap());

      await pumpTransportStationsScreen(tester);

      expect(find.text('Inactive Station'), findsNothing);
      expect(find.text('Aucune station disponible.'), findsOneWidget);
    });
  });
}
