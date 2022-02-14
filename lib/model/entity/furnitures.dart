class Furniture {
  Furniture({
    required this.id,
    required this.name,
    this.width,
    this.height,
    this.depth,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(id != null),
        assert(name != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  final int id;
  final String name;
  final int? width;
  final int? height;
  final int? depth;
  final String? remark;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get getId => id;
  String get getName => '$name';
  DateTime get getCreatedAt => createdAt;
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "width": width,
    "height": height,
    "depth": depth,
    "remark": remark,
    "created_at": createdAt.toUtc().toIso8601String(),
    "updated_at": updatedAt.toUtc().toIso8601String(),
  };

  factory Furniture.fromMap(Map<String, dynamic> json) => Furniture(
    id: json["id"],
    name: json["name"],
    width: json["width"],
    height: json["height"],
    depth: json["depth"],
    remark: json["remark"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
  );

  static List<Furniture> mainCache = [];
}