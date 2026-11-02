import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';
import 'package:waselni/features/transport/presentation/transport_lines_screen.dart';
import 'package:waselni/l10n/app_localizations.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  Future<void> pumpTransportScreen(
    WidgetTester tester, {
    required TransportType transportType,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: TransportLinesScreen(transportType: transportType),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('TransportLinesScreen', () {
    testWidgets('displays only lines matching the selected transport type', (
      tester,
    ) async {
      final now = DateTime(2026, 10, 31);

      final metroLine = LineModel(
        id: 'metro-1',
        name: 'Metro 1',
        code: 'M1',
        transportType: TransportType.metro,
        createdAt: now,
        updatedAt: now,
      );

      final busLine = LineModel(
        id: 'bus-1',
        name: 'Bus 1',
        code: 'B1',
        transportType: TransportType.bus,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('lines')
          .doc(metroLine.id)
          .set(metroLine.toMap());

      await fakeFirestore
          .collection('lines')
          .doc(busLine.id)
          .set(busLine.toMap());

      await pumpTransportScreen(tester, transportType: TransportType.metro);

      expect(find.text('Metro 1'), findsOneWidget);
      expect(find.text('Bus 1'), findsNothing);
    });

    testWidgets('displays the empty state when no matching lines exist', (
      tester,
    ) async {
      await pumpTransportScreen(tester, transportType: TransportType.bus);

      expect(
        find.text('Aucune ligne de transport disponible.'),
        findsOneWidget,
      );
    });

    testWidgets('does not display inactive lines', (tester) async {
      final now = DateTime(2026, 10, 31);

      final inactiveLine = LineModel(
        id: 'bus-1',
        name: 'Inactive Bus',
        code: 'B1',
        transportType: TransportType.bus,
        isActive: false,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('lines')
          .doc(inactiveLine.id)
          .set(inactiveLine.toMap());

      await pumpTransportScreen(tester, transportType: TransportType.bus);

      expect(find.text('Inactive Bus'), findsNothing);
      expect(
        find.text('Aucune ligne de transport disponible.'),
        findsOneWidget,
      );
    });
  });
}
