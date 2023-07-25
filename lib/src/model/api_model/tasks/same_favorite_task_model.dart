import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';

class SameFavoriteTaskModel {
  SameFavoriteTaskModel({
    required this.id,
    required this.name,
    required this.address,
    required this.budget,
    required this.image,
    required this.oplata,
    required this.startDate,
  });

  int id;
  String name;
  List<Address> address;
  int budget;
  String image;
  String oplata;
  DateTime startDate;

  factory SameFavoriteTaskModel.fromJson(Map<String, dynamic> json) => SameFavoriteTaskModel(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    address: json["address"] == null
        ? []
        : List<Address>.from(
      json["address"].map((x) => Address.fromJson(x)),
    ),
    budget: json["budget"] ?? 0,
    image: json["image"] ?? "",
    oplata: json["oplata"] ?? "",
    startDate: json["start_date"] == null
        ? DateTime.now()
        : DateTime.parse(json["start_date"]),
  );
}

class SameFavoriteTaskDataModel {
  SameFavoriteTaskDataModel({
    required this.data,
  });

  List<SameFavoriteTaskModel> data;

  factory SameFavoriteTaskDataModel.fromJson(Map<String, dynamic> json) =>
      SameFavoriteTaskDataModel(
        data: json["data"] == null
            ? List<SameFavoriteTaskModel>.from({})
            : List<SameFavoriteTaskModel>.from(
            json["data"].map((x) => SameFavoriteTaskModel.fromJson(x))),
      );
}
