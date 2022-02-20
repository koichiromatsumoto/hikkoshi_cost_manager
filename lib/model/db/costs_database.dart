import 'dart:io';

import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CostsDatabase {

  // DB作成時のデフォルト値
  final List<Cost> defaultCosts = [
    Cost(id: 1, name: "初回賃料", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
    Cost(id: 2, name: "初回管理費・共益費", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
    Cost(id: 3, name: "敷金・保証金", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
    Cost(id: 4, name: "礼金・権利金", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
    Cost(id: 5, name: "仲介手数料", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
    Cost(id: 6, name: "火災保険料", createdAt: DateTime.now(), updatedAt: DateTime.now(), type: CostType.rent.typeName),
  ];

  final _databaseName = "MyApp.db";
  final _databaseVersion = 1;

  CostsDatabase._();
  static final CostsDatabase instance = CostsDatabase._();
  static Database? _database;

  Future<Database> get database async =>
  _database ??= await _initDatabase();

  _initDatabase() async {
    final Directory documentsDirectory =
      await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createTable(db, version);
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    String costsSql = '''
      CREATE TABLE costs(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        budget_cost INTEGER,
        actual_cost INTEGER,
        remark TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''';

    String todosSql = '''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        deadline TEXT,
        is_done TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''';

    String photoFoldersSql = '''
      CREATE TABLE photo_folders(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''';

    String photosSql = '''
      CREATE TABLE photos(
        id INTEGER PRIMARY KEY,
        photo_folders_id INTEGER NOT NULL,
        text TEXT,
        file_path TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        foreign key (photo_folders_id) references photo_folders(id)
      )
    ''';

    await db.execute(costsSql);
    await db.execute(todosSql);
    await db.execute(photoFoldersSql);
    await db.execute(photosSql);
    defaultCosts.forEach((cost) async {
      await db.insert("costs", toMap(cost));
    });
  }

  Map<String, dynamic> toMap(Cost cost) {
    return {
      "id": cost.id,
      "name": cost.name,
      "budget_cost": cost.budgetCost,
      "actual_cost": cost.actualCost,
      "remark": cost.remark,
      "created_at": cost.createdAt.toUtc().toIso8601String(),
      "updated_at": cost.updatedAt.toUtc().toIso8601String(),
      "type": cost.type.toString(),
    };
  }

  // データベースの削除
  void destroyDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, _databaseName);
    await deleteDatabase(path);
  }
}