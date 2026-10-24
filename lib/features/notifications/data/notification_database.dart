import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../domain/notification_model.dart';

class NotificationDatabase {
  NotificationDatabase._();

  static final NotificationDatabase instance = NotificationDatabase._();

  static const String _table = 'notifications';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'waselni_notifications.db');

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            receivedAt TEXT NOT NULL,
            isRead INTEGER NOT NULL DEFAULT 0,
            targetScreen TEXT NOT NULL DEFAULT '/home'
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> save(NotificationModel notification) async {
    final db = await database;

    await db.insert(_table, {
      ...notification.toMap(),
      'isRead': notification.isRead ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NotificationModel>> getAll() async {
    final db = await database;

    final rows = await db.query(_table, orderBy: 'receivedAt DESC');

    return rows.map((row) {
      return NotificationModel.fromMap({...row, 'isRead': row['isRead'] == 1});
    }).toList();
  }

  Future<void> markAsRead(String id) async {
    final db = await database;

    await db.update(_table, {'isRead': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(String id) async {
    final db = await database;

    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
