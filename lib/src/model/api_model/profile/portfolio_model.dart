class PortfolioModel {
  PortfolioModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Datum> data;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? List<Datum>.from(<Datum>[])
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.comment,
    required this.description,
    required this.images,
  });

  int id;
  int userId;
  String comment;
  String description;
  List<String> images;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        comment: json["comment"] ?? "",
        description: json["description"] ?? "",
        images: json["images"] == null
            ? List<String>.from(<String>[])
            : List<String>.from(json["images"].map((x) => x)),
      );
}
