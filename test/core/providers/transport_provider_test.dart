import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/core/providers/auth_provider.dart';
import 'package:waselni/core/providers/transport_provider.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/station_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ProviderContainer container;
  late ProviderSubscription<AsyncValue<List<LineModel>>> linesSubscription;
  late ProviderSubscription<AsyncValue<List<StationModel>>> stationsSubscription;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();

    container = ProviderContainer(
      overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
    );

    linesSubscription = container.listen(
      linesProvider,
      (previous, next) {},
    );

    stationsSubscription = container.listen(
      stationsProvider,
      (previous, next) {},
    );
  });

  tearDown(() {
    linesSubscription.close();
    stationsSubscription.close();
    container.dispose();
  });

  group('Transport providers', () {
    test('linesProvider emits Firestore lines', () async {
      final now = DateTime(2026, 10, 31);

      final line = LineModel(
        id: 'line-1',
        name: 'Metro 1',
        code: 'M1',
        transportType: TransportType.metro,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore.collection('lines').doc(line.id).set(line.toMap());

      final result = await container.read(linesProvider.future);

      expect(result, hasLength(1));
      expect(result.first.name, 'Metro 1');
    });

    test('stationsProvider emits Firestore stations', () async {
      final now = DateTime(2026, 10, 31);

      final station = StationModel(
        id: 'station-1',
        name: 'Barcelona',
        latitude: 36.8065,
        longitude: 10.1815,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('stations')
          .doc(station.id)
          .set(station.toMap());

      final result = await container.read(stationsProvider.future);

      expect(result, hasLength(1));
      expect(result.first.name, 'Barcelona');
    });

    test('activeLinesProvider excludes inactive lines', () async {
      final now = DateTime(2026, 10, 31);

      final activeLine = LineModel(
        id: 'line-1',
        name: 'Metro 1',
        code: 'M1',
        transportType: TransportType.metro,
        createdAt: now,
        updatedAt: now,
      );

      final inactiveLine = LineModel(
        id: 'line-2',
        name: 'Bus 2',
        code: 'B2',
        transportType: TransportType.bus,
        isActive: false,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('lines')
          .doc('line-1')
          .set(activeLine.toMap());

      await fakeFirestore
          .collection('lines')
          .doc('line-2')
          .set(inactiveLine.toMap());

      await container.read(linesProvider.future);
      final result = container.read(activeLinesProvider).requireValue;

      expect(result, hasLength(1));
      expect(result.first.id, 'line-1');
    });

    test('activeStationsProvider excludes inactive stations', () async {
      final now = DateTime(2026, 10, 31);

      final activeStation = StationModel(
        id: 'station-1',
        name: 'Barcelona',
        latitude: 36.8065,
        longitude: 10.1815,
        createdAt: now,
        updatedAt: now,
      );

      final inactiveStation = StationModel(
        id: 'station-2',
        name: 'Inactive Station',
        latitude: 36.8000,
        longitude: 10.1800,
        isActive: false,
        createdAt: now,
        updatedAt: now,
      );

      await fakeFirestore
          .collection('stations')
          .doc('station-1')
          .set(activeStation.toMap());

      await fakeFirestore
          .collection('stations')
          .doc('station-2')
          .set(inactiveStation.toMap());

      await container.read(stationsProvider.future);
      final result = container.read(activeStationsProvider).requireValue;

      expect(result, hasLength(1));
      expect(result.first.id, 'station-1');
    });
  });
}
