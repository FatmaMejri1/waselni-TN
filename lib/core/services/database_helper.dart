import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../features/transport/domain/line_model.dart';
import '../../features/transport/domain/station_model.dart';
import '../../features/schedules/domain/schedule_model.dart';
import '../../features/schedules/domain/schedule_source.dart';
import '../../features/schedules/domain/schedule_status.dart';
import '../../features/transport/domain/transport_type.dart';

class DatabaseHelper {
  DatabaseHelper._();

  DatabaseHelper.forTesting(Database database) : _database = database;

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _databaseName = 'waselni.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) => createSchemaForTesting(db),
    );
  }

  static Future<void> createSchemaForTesting(Database db) async {
    await db.execute('''
      CREATE TABLE lines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        transportType TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        stationIds TEXT NOT NULL DEFAULT '[]',
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE stations (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE schedules (
        id TEXT PRIMARY KEY,
        lineId TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        days TEXT NOT NULL,
        source TEXT NOT NULL,
        status TEXT NOT NULL,
        submittedBy TEXT NOT NULL,
        reviewedBy TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (lineId) REFERENCES lines (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_schedules_lineId ON schedules(lineId)');

    await db.execute('CREATE INDEX idx_schedules_status ON schedules(status)');
  }

  Future<void> insertLine(LineModel line) async {
    final db = await database;

    await db.insert('lines', {
      'id': line.id,
      'name': line.name,
      'code': line.code,
      'transportType': line.transportType.name,
      'description': line.description,
      'stationIds': jsonEncode(line.stationIds),
      'isActive': line.isActive ? 1 : 0,
      'createdAt': line.createdAt.millisecondsSinceEpoch,
      'updatedAt': line.updatedAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateLine(LineModel line) async {
    final db = await database;

    await db.update(
      'lines',
      {
        'name': line.name,
        'code': line.code,
        'transportType': line.transportType.name,
        'description': line.description,
        'stationIds': jsonEncode(line.stationIds),
        'isActive': line.isActive ? 1 : 0,
        'updatedAt': line.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [line.id],
    );
  }

  Future<List<LineModel>> getAllLines() async {
    final db = await database;
    final maps = await db.query('lines', orderBy: 'name ASC');

    return maps.map((map) {
      return LineModel(
        id: map['id'] as String,
        name: map['name'] as String,
        code: map['code'] as String,
        transportType: TransportType.values.firstWhere(
          (type) => type.name == map['transportType'],
          orElse: () => TransportType.other,
        ),
        description: map['description'] as String,
        stationIds: List<String>.from(
          jsonDecode(map['stationIds'] as String) as List,
        ),
        isActive: map['isActive'] == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );
    }).toList();
  }

  Future<void> deleteLine(String id) async {
    final db = await database;
    await db.delete('lines', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertStation(StationModel station) async {
    final db = await database;

    await db.insert('stations', {
      'id': station.id,
      'name': station.name,
      'latitude': station.latitude,
      'longitude': station.longitude,
      'isActive': station.isActive ? 1 : 0,
      'createdAt': station.createdAt.millisecondsSinceEpoch,
      'updatedAt': station.updatedAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateStation(StationModel station) async {
    final db = await database;

    await db.update(
      'stations',
      {
        'name': station.name,
        'latitude': station.latitude,
        'longitude': station.longitude,
        'isActive': station.isActive ? 1 : 0,
        'updatedAt': station.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [station.id],
    );
  }

  Future<List<StationModel>> getAllStations() async {
    final db = await database;
    final maps = await db.query('stations', orderBy: 'name ASC');

    return maps.map((map) {
      return StationModel(
        id: map['id'] as String,
        name: map['name'] as String,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        isActive: map['isActive'] == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );
    }).toList();
  }

  Future<void> deleteStation(String id) async {
    final db = await database;
    await db.delete('stations', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertSchedule(ScheduleModel schedule) async {
    final db = await database;

    await db.insert('schedules', {
      'id': schedule.id,
      'lineId': schedule.lineId,
      'departureTime': schedule.departureTime,
      'days': jsonEncode(schedule.days),
      'source': schedule.source.name,
      'status': schedule.status.name,
      'submittedBy': schedule.submittedBy,
      'reviewedBy': schedule.reviewedBy,
      'createdAt': schedule.createdAt.millisecondsSinceEpoch,
      'updatedAt': schedule.updatedAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateSchedule(ScheduleModel schedule) async {
    final db = await database;

    await db.update(
      'schedules',
      {
        'lineId': schedule.lineId,
        'departureTime': schedule.departureTime,
        'days': jsonEncode(schedule.days),
        'source': schedule.source.name,
        'status': schedule.status.name,
        'submittedBy': schedule.submittedBy,
        'reviewedBy': schedule.reviewedBy,
        'updatedAt': schedule.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<List<ScheduleModel>> getAllSchedules() async {
    final db = await database;
    final maps = await db.query('schedules', orderBy: 'departureTime ASC');

    return maps.map((map) {
      return ScheduleModel(
        id: map['id'] as String,
        lineId: map['lineId'] as String,
        departureTime: map['departureTime'] as String,
        days: List<int>.from(jsonDecode(map['days'] as String) as List),
        source: ScheduleSource.values.firstWhere(
          (source) => source.name == map['source'],
          orElse: () => ScheduleSource.community,
        ),
        status: ScheduleStatus.values.firstWhere(
          (status) => status.name == map['status'],
          orElse: () => ScheduleStatus.pending,
        ),
        submittedBy: map['submittedBy'] as String,
        reviewedBy: map['reviewedBy'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );
    }).toList();
  }

  Future<void> deleteSchedule(String id) async {
    final db = await database;
    await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }
}
