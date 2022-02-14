import 'dart:async';

import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/furnitures.dart';

class FurnitureRepository {
  static String table = 'furnitures';
  static CostsDatabase instance = CostsDatabase.instance;

  static void create({name, int? width = null, int? height = null, int? depth = null, String? remark = null}) async {
    String now = DateTime.now().toString();
    final Map<String, dynamic> row = {
      'name': name,
      'width': width,
      'height': height,
      'depth': depth,
      'remark': remark,
      'created_at': now,
      'updated_at': now,
    };

    final db = await instance.database;
    await db.insert(table, row);
  }

  static Future<List<Furniture>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Furniture.fromMap(e)).toList();
  }

  static void update({id, name, int? width = null, int? height = null, int? depth = null, String? remark = null}) async {
    String now = DateTime.now().toString();
    final row = {
      'name': name,
      'width': width,
      'height': height,
      'depth': depth,
      'remark': remark,
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