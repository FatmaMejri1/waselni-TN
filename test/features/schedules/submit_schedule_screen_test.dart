import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waselni/core/constants/firestore_paths.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/features/auth/data/auth_service.dart';
import 'package:waselni/features/schedules/presentation/submit_schedule_screen.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';
import 'package:waselni/l10n/app_localizations.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockAuthService mockAuthService;

  Future<void> pumpSubmitScheduleScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: const SubmitScheduleScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> seedActiveLine() async {
    final now = DateTime(2026, 10, 31);

    final line = LineModel(
      id: 'metro-1',
      name: 'Metro 1',
      code: 'M1',
      transportType: TransportType.metro,
      createdAt: now,
      updatedAt: now,
    );

    await fakeFirestore
        .collection(FirestorePaths.lines)
        .doc(line.id)
        .set(line.toMap());
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuthService = MockAuthService();
  });

  group('SubmitScheduleScreen', () {
    testWidgets('displays the form with active lines', (tester) async {
      await seedActiveLine();

      when(() => mockAuthService.currentUser).thenReturn(null);

      await pumpSubmitScheduleScreen(tester);

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(7));

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('M1 - Metro 1'), findsOneWidget);
    });

    testWidgets('displays validation errors when submitting an empty form', (
      tester,
    ) async {
      await seedActiveLine();

      when(() => mockAuthService.currentUser).thenReturn(null);

      await pumpSubmitScheduleScreen(tester);

      await tester.ensureVisible(find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Sélectionnez une ligne de transport'),
        findsNWidgets(2),
      );
      expect(find.text("Choisissez l'heure de départ"), findsNWidgets(2));
      expect(
        find.text('Sélectionnez au moins un jour de circulation.'),
        findsOneWidget,
      );

      expect(
        await fakeFirestore.collection(FirestorePaths.schedules).get(),
        isA<Object>(),
      );
      expect(
        (await fakeFirestore.collection(FirestorePaths.schedules).get()).docs,
        isEmpty,
      );
    });

    testWidgets('displays an empty state when there are no active lines', (
      tester,
    ) async {
      await pumpSubmitScheduleScreen(tester);

      expect(
        find.text('Aucune ligne de transport active disponible.'),
        findsOneWidget,
      );
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    });
  });
}
