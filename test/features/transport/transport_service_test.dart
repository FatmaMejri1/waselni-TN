import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/features/transport/data/transport_service.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/station_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TransportService transportService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    transportService = TransportService(firestore: fakeFirestore);
  });

  group('Line operations', () {
    final now = DateTime(2026, 10, 31);

    final line = LineModel(
      id: 'line-1',
      name: 'Metro 1',
      code: 'M1',
      transportType: TransportType.metro,
      stationIds: const ['station-1', 'station-2'],
      createdAt: now,
      updatedAt: now,
    );

    test('creates and retrieves a line', () async {
      await transportService.createLine(line);

      final result = await transportService.getLine('line-1');

      expect(result, isNotNull);
      expect(result!.name, 'Metro 1');
      expect(result.code, 'M1');
      expect(result.transportType, TransportType.metro);
      expect(result.stationIds, ['station-1', 'station-2']);
    });

    test('returns null when a line does not exist', () async {
      final result = await transportService.getLine('unknown');

      expect(result, isNull);
    });

    test('updates a line', () async {
      await transportService.createLine(line);

      final updatedLine = LineModel(
        id: line.id,
        name: 'Metro 1 Updated',
        code: line.code,
        transportType: line.transportType,
        stationIds: line.stationIds,
        createdAt: line.createdAt,
        updatedAt: now,
      );

      await transportService.updateLine(updatedLine);

      final result = await transportService.getLine('line-1');

      expect(result!.name, 'Metro 1 Updated');
    });

    test('deactivates a line', () async {
      await transportService.createLine(line);

      await transportService.deactivateLine('line-1');

      final result = await transportService.getLine('line-1');

      expect(result!.isActive, isFalse);
    });
  });

  group('Station operations', () {
    final now = DateTime(2026, 10, 31);

    final station = StationModel(
      id: 'station-1',
      name: 'Barcelona',
      latitude: 36.8065,
      longitude: 10.1815,
      createdAt: now,
      updatedAt: now,
    );

    test('creates and retrieves a station', () async {
      await transportService.createStation(station);

      final result = await transportService.getStation('station-1');

      expect(result, isNotNull);
      expect(result!.name, 'Barcelona');
      expect(result.latitude, 36.8065);
      expect(result.longitude, 10.1815);
    });

    test('returns null when a station does not exist', () async {
      final result = await transportService.getStation('unknown');

      expect(result, isNull);
    });

    test('updates a station', () async {
      await transportService.createStation(station);

      final updatedStation = StationModel(
        id: station.id,
        name: 'Barcelona Centre',
        latitude: station.latitude,
        longitude: station.longitude,
        createdAt: station.createdAt,
        updatedAt: now,
      );

      await transportService.updateStation(updatedStation);

      final result = await transportService.getStation('station-1');

      expect(result!.name, 'Barcelona Centre');
    });

    test('deactivates a station', () async {
      await transportService.createStation(station);

      await transportService.deactivateStation('station-1');

      final result = await transportService.getStation('station-1');

      expect(result!.isActive, isFalse);
    });
  });
}
