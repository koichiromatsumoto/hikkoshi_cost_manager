import 'dart:async';

import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:sqflite/sqflite.dart';

class CostRepository {
  static String table = 'costs';
  static CostsDatabase instance = CostsDatabase.instance;

  static void create({text, type, int? budgetCost = null, int? actualCost = null}) async {
    DateTime now = DateTime.now();
    final Map<String, dynamic> row = {
      'name': text,
      'budget_cost': budgetCost,
      'actual_cost': actualCost,
      'created_at': now.toString(),
      'updated_at': now.toString(),
      'type': type,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);
  }

  static Future<List<Cost>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Cost.fromMap(e)).toList();
  }

  static Future<List<Cost>> getTypeAll(String? type) async {
    var db = await instance.database;
    var rows =
    await db.rawQuery('SELECT * FROM $table WHERE type = ? ORDER BY id ASC', [type]);
    if (rows.isEmpty) {
      return [];
    }
    return rows.map((e) => Cost.fromMap(e)).toList();
  }

  static void nameUpdate({required int id, required String name}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'name': name,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void budgetCostUpdate({required int id, required int budgetCost}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'budget_cost': budgetCost,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void budgetCostDelete({required int id}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'budget_cost': null,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void actualCostUpdate({required int id, required int actualCost}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'actual_cost': actualCost,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void actualCostDelete({required int id}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'actual_cost': null,
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