class TemplateModel {
  TemplateModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Datum> data;

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? List<Datum>.from(<Datum>[])
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.text,
  });

  int id;
  String title;
  String text;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        text: json["text"] ?? "",
      );
}
