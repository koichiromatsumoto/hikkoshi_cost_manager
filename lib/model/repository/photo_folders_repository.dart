import 'dart:async';

import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/photo_folders.dart';

class PhotoFolderRepository {
  static String table = 'photo_folders';
  static CostsDatabase instance = CostsDatabase.instance;

  static void create({name}) async {
    String now = DateTime.now().toString();
    final Map<String, dynamic> row = {
      'name': name,
      'created_at': now,
      'updated_at': now,
    };

    final db = await instance.database;
    await db.insert(table, row);
  }

  static Future<List<PhotoFolder>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => PhotoFolder.fromMap(e)).toList();
  }

  static void update({id, name}) async {
    String now = DateTime.now().toString();
    final row = {
      'name': name,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void delete(int id) async {
    final db = await instance.database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}