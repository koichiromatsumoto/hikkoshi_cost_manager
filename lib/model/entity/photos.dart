class Photo {
  Photo({
    required this.id,
    required this.text,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
    required this.photoFoldersId,
  }) : assert(id != null),
        assert(text != null),
        assert(filePath != null),
        assert(createdAt != null),
        assert(updatedAt != null),
        assert(photoFoldersId != null);

  final int id;
  final String text;
  final String filePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int photoFoldersId;

  int get getId => id;
  String get getName => '$text';
  DateTime get getCreatedAt => createdAt;
  DateTime get getUpdatedAt => updatedAt;
  int get getPhotoFoldersId => photoFoldersId;

  Map<String, dynamic> toMap() => {
    "id": id,
    "text": text,
    "file_path": filePath,
    "created_at": createdAt.toUtc().toIso8601String(),
    "updated_at": updatedAt.toUtc().toIso8601String(),
    "photo_folders_id": photoFoldersId,
  };

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
    id: json["id"],
    text: json["text"],
    filePath: json["file_path"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
    photoFoldersId: json["photo_folders_id"],
  );

  static Future<int> fromMapCount(Map<String, dynamic> json) {
    return json["count"];
  }

  static List<Photo> mainCache = [];
}