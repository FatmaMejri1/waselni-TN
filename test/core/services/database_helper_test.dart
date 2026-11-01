import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:waselni/core/services/database_helper.dart';
import 'package:waselni/features/transport/domain/line_model.dart';
import 'package:waselni/features/transport/domain/station_model.dart';
import 'package:waselni/features/transport/domain/transport_type.dart';
import 'package:waselni/features/schedules/domain/schedule_model.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late Database database;

  final now = DateTime.utc(2026, 1, 1);

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await DatabaseHelper.createSchemaForTesting(db);
        },
      ),
    );

    databaseHelper = DatabaseHelper.forTesting(database);
  });

  tearDown(() async {
    await database.close();
  });

  LineModel createLine() {
    return LineModel(
      id: 'line-1',
      name: 'Metro 1',
      code: 'M1',
      transportType: TransportType.metro,
      stationIds: const ['station-1'],
      createdAt: now,
      updatedAt: now,
    );
  }

  StationModel createStation() {
    return StationModel(
      id: 'station-1',
      name: 'Barcelona',
      latitude: 36.8008,
      longitude: 10.1800,
      createdAt: now,
      updatedAt: now,
    );
  }

  ScheduleModel createSchedule() {
    return ScheduleModel(
      id: 'schedule-1',
      lineId: 'line-1',
      departureTime: '08:30',
      days: const [1, 2, 3, 4, 5],
      submittedBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    );
  }

  group('DatabaseHelper - Lines', () {
    test('inserts and retrieves a line', () async {
      await databaseHelper.insertLine(createLine());

      final lines = await databaseHelper.getAllLines();

      expect(lines, hasLength(1));
      expect(lines.first.name, 'Metro 1');
      expect(lines.first.transportType, TransportType.metro);
      expect(lines.first.stationIds, ['station-1']);
    });

    test('updates a line', () async {
      await databaseHelper.insertLine(createLine());

      final updatedLine = LineModel(
        id: 'line-1',
        name: 'Metro 1 Updated',
        code: 'M1',
        transportType: TransportType.metro,
        createdAt: now,
        updatedAt: now.add(const Duration(days: 1)),
      );

      await databaseHelper.updateLine(updatedLine);

      final lines = await databaseHelper.getAllLines();

      expect(lines.first.name, 'Metro 1 Updated');
    });

    test('deletes a line', () async {
      await databaseHelper.insertLine(createLine());

      await databaseHelper.deleteLine('line-1');

      expect(await databaseHelper.getAllLines(), isEmpty);
    });
  });

  group('DatabaseHelper - Stations', () {
    test('inserts and retrieves a station', () async {
      await databaseHelper.insertStation(createStation());

      final stations = await databaseHelper.getAllStations();

      expect(stations, hasLength(1));
      expect(stations.first.name, 'Barcelona');
      expect(stations.first.latitude, 36.8008);
    });

    test('updates a station', () async {
      await databaseHelper.insertStation(createStation());

      final updatedStation = StationModel(
        id: 'station-1',
        name: 'Barcelona Updated',
        latitude: 36.8008,
        longitude: 10.1800,
        createdAt: now,
        updatedAt: now.add(const Duration(days: 1)),
      );

      await databaseHelper.updateStation(updatedStation);

      final stations = await databaseHelper.getAllStations();

      expect(stations.first.name, 'Barcelona Updated');
    });

    test('deletes a station', () async {
      await databaseHelper.insertStation(createStation());

      await databaseHelper.deleteStation('station-1');

      expect(await databaseHelper.getAllStations(), isEmpty);
    });
  });

  group('DatabaseHelper - Schedules', () {
    setUp(() async {
      await databaseHelper.insertLine(createLine());
    });

    test('inserts and retrieves a schedule', () async {
      await databaseHelper.insertSchedule(createSchedule());

      final schedules = await databaseHelper.getAllSchedules();

      expect(schedules, hasLength(1));
      expect(schedules.first.departureTime, '08:30');
      expect(schedules.first.days, [1, 2, 3, 4, 5]);
    });

    test('updates a schedule', () async {
      await databaseHelper.insertSchedule(createSchedule());

      final updatedSchedule = ScheduleModel(
        id: 'schedule-1',
        lineId: 'line-1',
        departureTime: '09:00',
        days: const [1, 2, 3],
        submittedBy: 'user-1',
        createdAt: now,
        updatedAt: now.add(const Duration(days: 1)),
      );

      await databaseHelper.updateSchedule(updatedSchedule);

      final schedules = await databaseHelper.getAllSchedules();

      expect(schedules.first.departureTime, '09:00');
      expect(schedules.first.days, [1, 2, 3]);
    });

    test('deletes a schedule', () async {
      await databaseHelper.insertSchedule(createSchedule());

      await databaseHelper.deleteSchedule('schedule-1');

      expect(await databaseHelper.getAllSchedules(), isEmpty);
    });

    test('deleting a line also deletes its schedules', () async {
      await databaseHelper.insertSchedule(createSchedule());

      await databaseHelper.deleteLine('line-1');

      expect(await databaseHelper.getAllSchedules(), isEmpty);
    });
  });
}
