class PhotoFolder {
  PhotoFolder({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(id != null),
        assert(name != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get getId => id;
  String get getName => '$name';
  DateTime get getCreatedAt => createdAt;
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toUtc().toIso8601String(),
    "updated_at": updatedAt.toUtc().toIso8601String(),
  };

  factory PhotoFolder.fromMap(Map<String, dynamic> json) => PhotoFolder(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
  );

  static List<PhotoFolder> mainCache = [];
  static int countCache = 0;
}