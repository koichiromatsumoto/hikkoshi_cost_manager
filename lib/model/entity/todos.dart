class Todo {
  Todo({
    required this.id,
    required this.name,
    this.deadline,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(id != null),
        assert(name != null),
        assert(isDone != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  final int id;
  final String name;
  final DateTime? deadline;
  final String isDone;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get getId => id;
  String get getName => '$name';
  DateTime get getCreatedAt => createdAt;
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "deadline": deadline!.toUtc().toIso8601String(),
    "is_done": isDone,
    "created_at": createdAt.toUtc().toIso8601String(),
    "updated_at": updatedAt.toUtc().toIso8601String(),
  };

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
    id: json["id"],
    name: json["name"],
    deadline: json["deadline"] != "" ? DateTime.parse(json["deadline"]).toLocal() : null,
    isDone: json["is_done"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
  );

  static List<Todo> mainCache = [];
}