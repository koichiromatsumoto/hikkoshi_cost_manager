import 'dart:async';

import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/todos.dart';

class TodoRepository {
  static String table = 'todos';
  static CostsDatabase instance = CostsDatabase.instance;

  static void create({name, DateTime? deadline = null, String? isDone = "false"}) async {
    String now = DateTime.now().toString();
    String? deadlineStr = deadline != null ? deadline.toString() : "";
    final Map<String, dynamic> row = {
      'name': name,
      'deadline': deadlineStr,
      'is_done': isDone,
      'created_at': now,
      'updated_at': now,
    };

    final db = await instance.database;
    await db.insert(table, row);
  }

  static Future<List<Todo>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Todo.fromMap(e)).toList();
  }

  static Future<List<Todo>> getDoneAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table WHERE is_done = "false" ORDER BY id ASC');
    if (rows.isEmpty) return [];

    return rows.map((e) => Todo.fromMap(e)).toList();
  }

  static void update({id, name, DateTime? deadline = null}) async {
    String now = DateTime.now().toString();
    String? deadlineStr = deadline != null ? deadline.toString() : "";
    final row = {
      'name': name,
      'deadline': deadlineStr,
      'updated_at': now,
    };
    final db = await instance.database;
    await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static void updateIsDone({id, isDone}) async {
    String now = DateTime.now().toString();
    final row = {
      'is_done': isDone,
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