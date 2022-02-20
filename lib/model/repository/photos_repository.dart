import 'dart:async';
import 'dart:convert';

import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/photos.dart';

class PhotoRepository {
  static String table = 'photos';
  static CostsDatabase instance = CostsDatabase.instance;

  static void create({photoFoldersId, path, String? text = null}) async {
    String now = DateTime.now().toString();
    final Map<String, dynamic> row = {
      'photo_folders_id': photoFoldersId,
      'text': text,
      'path': path,
      'created_at': now,
      'updated_at': now,
    };

    final db = await instance.database;
    await db.insert(table, row);
  }

  static Future<List<Photo>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Photo.fromMap(e)).toList();
  }

  static Future<List<Photo>> getFoldersAll(int photoFoldersId) async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM photos where photo_folders_id = $photoFoldersId ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Photo.fromMap(e)).toList();
  }

  static Future<int> getFoldersCount(int photoFoldersId) async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM photos where photo_folders_id = $photoFoldersId ORDER BY id ASC');
    if (rows.isEmpty) return 0;

    return Photo.fromMapCount(rows.first);
  }

  static void textUpdate({id, text}) async {
    String now = DateTime.now().toString();
    final row = {
      'text': text,
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