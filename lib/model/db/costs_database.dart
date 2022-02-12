import 'dart:io';

import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CostsDatabase {
  final String _tableName = 'costs';
  final String _columnId = 'id';
  final String _columnName = 'name';
  final String _columnBudgetCost = 'budget_cost';
  final String _columnActualCost = 'actual_cost';
  final String _columnRemark = 'remark';
  final String _columnCreatedAt = 'created_at';
  final String _columnUpdatedAt = 'updated_at';
  final String _columnType = 'type';

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
    String sql = '''
      CREATE TABLE $_tableName(
        $_columnId INTEGER PRIMARY KEY,
        $_columnName TEXT NOT NULL,
        $_columnBudgetCost INTEGER,
        $_columnActualCost INTEGER,
        $_columnRemark TEXT,
        $_columnCreatedAt TEXT NOT NULL,
        $_columnUpdatedAt TEXT NOT NULL,
        $_columnType TEXT NOT NULL
      )
    ''';

    await db.execute(sql);
    defaultCosts.forEach((cost) async {
      await db.insert(_tableName, toMap(cost));
    });
  }

  Future<List<Cost>> loadAllCost() async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_columnCreatedAt DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<List<Cost>> loadTypeCost(CostType type) async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      where: 'type = ?',
      whereArgs: [type],
      orderBy: '$_columnCreatedAt DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  Future insert(Cost cost) async {
    final db = await database;
    return await db.insert(_tableName, toMap(cost));
  }

  Future insertDefaultCosts(List<Cost> costs) async {
    final db = await database;
    return costs.forEach((cost) async {
      await db.insert(_tableName, toMap(cost));
    });
  }

  Future update(Cost cost) async {
    final db = await database;
    return await db.update(
      _tableName,
      toMap(cost),
      where: '$_columnId = ?',
      whereArgs: [cost.id],
    );
  }

  Future delete(Cost cost) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [cost.id],
    );
  }

  Map<String, dynamic> toMap(Cost cost) {
    return {
      _columnId: cost.id,
      _columnName: cost.name,
      _columnBudgetCost: cost.budgetCost,
      _columnActualCost: cost.actualCost,
      _columnRemark: cost.remark,
      _columnCreatedAt: cost.createdAt.toUtc().toIso8601String(),
      _columnUpdatedAt: cost.updatedAt.toUtc().toIso8601String(),
      _columnType: cost.type.toString(),
    };
  }

  Cost fromMap(Map<String, dynamic> json) {
    return Cost(
      id: json[_columnId],
      name: json[_columnName],
      budgetCost: json[_columnBudgetCost],
      actualCost: json[_columnActualCost],
      remark: json[_columnRemark],
      createdAt: DateTime.parse(json[_columnCreatedAt]).toLocal(),
      updatedAt: DateTime.parse(json[_columnUpdatedAt]).toLocal(),
      type: json[_columnType]
    );
  }

  void destroyDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, _databaseName);
    await deleteDatabase(path); // データベースの削除
  }

  void setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, _databaseName);
    await deleteDatabase(path);

    await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreatingDatabase,
        onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  _onCreatingDatabase(Database database, int version) async {
    String sql = '''
      CREATE TABLE $_tableName(
        $_columnId INTEGER PRIMARY KEY,
        $_columnName TEXT NOT NULL,
        $_columnBudgetCost INTEGER,
        $_columnActualCost INTEGER,
        $_columnRemark TEXT,
        $_columnCreatedAt TEXT NOT NULL,
        $_columnUpdatedAt TEXT NOT NULL,
        $_columnType TEXT NOT NULL
      )
    ''';
    await database.execute(sql);
    defaultCosts.forEach((cost) async {
      await database.insert(_tableName, toMap(cost));
    });
  }
}