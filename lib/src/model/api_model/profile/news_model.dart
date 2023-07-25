class NewsModel {
  NewsModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Datum> data;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.text,
    required this.img,
    required this.createdAt,
  });

  int id;
  String title;
  String text;
  String img;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        text: json["text"] ?? "",
        img: json["img"] ?? "",
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
      );
}
