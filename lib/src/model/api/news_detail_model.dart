class NewsDetailModel {
  NewsDetailModel({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) =>
      NewsDetailModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.text,
    required this.desc,
    required this.img,
    required this.createdAt,
  });

  int id;
  String title;
  String text;
  String desc;
  String img;
  DateTime createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        text: json["text"] ?? "",
        desc: json["desc"] ?? "",
        img: json["img"] ?? "",
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
      );
}
