import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Date key used for storage, for example "2026-10-30".
String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Stores one row per day on the phone. Each row holds that day's values as JSON.
class TrackerDb {
  static Database? _db;

  static Future<Database> get _database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'tracker.db'),
      version: 1,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE days(date TEXT PRIMARY KEY, data TEXT NOT NULL)',
      ),
    );
    return _db!;
  }

  static Future<Map<String, dynamic>> load(String date) async {
    final db = await _database;
    final rows = await db.query('days', where: 'date = ?', whereArgs: [date]);
    if (rows.isEmpty) return {};
    return jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
  }

  static Future<void> save(String date, Map<String, dynamic> data) async {
    final db = await _database;
    await db.insert(
      'days',
      {'date': date, 'data': jsonEncode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, Map<String, dynamic>>> loadAll() async {
    final db = await _database;
    final rows = await db.query('days', orderBy: 'date ASC');
    return {
      for (final r in rows)
        r['date'] as String:
            jsonDecode(r['data'] as String) as Map<String, dynamic>,
    };
  }

  static Future<void> importAll(Map<String, Map<String, dynamic>> all) async {
    final db = await _database;
    final batch = db.batch();
    all.forEach((date, data) {
      batch.insert(
        'days',
        {'date': date, 'data': jsonEncode(data)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit(noResult: true);
  }
}
