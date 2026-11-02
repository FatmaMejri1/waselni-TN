import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/features/schedules/domain/schedule_model.dart';
import 'package:waselni/features/schedules/domain/schedule_source.dart';
import 'package:waselni/features/schedules/domain/schedule_status.dart';
import 'package:waselni/features/schedules/presentation/schedules_screen.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';
import 'package:waselni/l10n/app_localizations.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  Future<void> pumpSchedulesScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: const Scaffold(body: SchedulesScreen()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('SchedulesScreen', () {
    testWidgets('displays empty state and submission button', (tester) async {
      await pumpSchedulesScreen(tester);

      expect(find.text('Proposer un horaire'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(
        find.text('Aucun horaire disponible pour le moment.'),
        findsOneWidget,
      );
    });

    testWidgets('displays an approved schedule with its line information', (
      tester,
    ) async {
      final now = DateTime(2026, 10, 31);

      final line = LineModel(
        id: 'metro-1',
        name: 'Metro 1',
        code: 'M1',
        transportType: TransportType.metro,
        createdAt: now,
        updatedAt: now,
      );

      final schedule = ScheduleModel(
        id: 'schedule-1',
        lineId: line.id,
        departureTime: '08:30',
        days: const [1, 2, 3],
        source: ScheduleSource.official,
        status: ScheduleStatus.approved,
        submittedBy: 'admin-1',
        reviewedBy: 'admin-1',
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore.collection('lines').doc(line.id).set(line.toMap());

      await fakeFirestore
          .collection('schedules')
          .doc(schedule.id)
          .set(schedule.toMap());

      await pumpSchedulesScreen(tester);

      expect(find.text('M1 - Metro 1'), findsOneWidget);
      expect(find.textContaining('08:30'), findsOneWidget);
      expect(find.textContaining('Lundi'), findsOneWidget);
      expect(find.textContaining('Mardi'), findsOneWidget);
      expect(find.textContaining('Mercredi'), findsOneWidget);
    });
  });
}
