import 'package:flutter/foundation.dart';

class Cost {
  Cost({
    required this.id,
    required this.name,
    this.budgetCost,
    this.actualCost,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.total
  }) : assert(id != null),
        assert(name != null),
        assert(createdAt != null),
        assert(updatedAt != null),
        assert(type != null);

  final int id;
  final String name;
  final int? budgetCost;
  final int? actualCost;
  final String? remark;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? type;
  final String? total;

  int get getId => id;
  String get getName => '$name';
  DateTime get getCreatedAt => createdAt;
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "budget_cost": budgetCost,
    "actual_cost": actualCost,
    "created_at": createdAt.toUtc().toIso8601String(),
    "updated_at": updatedAt.toUtc().toIso8601String(),
    "type": type,
  };

  factory Cost.fromMap(Map<String, dynamic> json) => Cost(
    id: json["id"],
    name: json["name"],
    budgetCost: json["budget_cost"],
    actualCost: json["actual_cost"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
    type: json["type"],
  );

  static List<Cost> costCache = [];
  static List<Cost> mainCache = [];
}

enum CostType {
  rent, // 賃貸
  furniture, // 家具家電
  other, // その他
}

final typeNames = {
  CostType.rent: 'rent',
  CostType.furniture: 'furniture',
  CostType.other: 'other'
};

final typeStrs = {
  CostType.rent: '賃貸',
  CostType.furniture: '家具家電',
  CostType.other: 'その他'
};

extension TypeExtension on CostType {
  String? get typeName => typeNames[this];
  String? get typeStr => typeStrs[this];
}

enum CostKind {
  budgetCost, // 予算
  actualCost // 実際の費用
}