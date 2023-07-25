import 'dart:convert';

StatusModel statusModelFromJson(String str) =>
    StatusModel.fromJson(json.decode(str));

class StatusModel {
  StatusModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Status> data;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? List<Status>.from([])
            : List<Status>.from(json["data"].map((x) => Status.fromJson(x))),
      );
}

class Status {
  Status({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["updated_at"]),
      );
}
