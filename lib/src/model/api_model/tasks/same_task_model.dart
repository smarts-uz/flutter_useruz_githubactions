import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';

class SameTaskModel {
  SameTaskModel({
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

  factory SameTaskModel.fromJson(Map<String, dynamic> json) => SameTaskModel(
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

class SameTaskDataModel {
  SameTaskDataModel({
    required this.data,
  });

  List<SameTaskModel> data;

  factory SameTaskDataModel.fromJson(Map<String, dynamic> json) =>
      SameTaskDataModel(
        data: json["data"] == null
            ? List<SameTaskModel>.from({})
            : List<SameTaskModel>.from(
                json["data"].map((x) => SameTaskModel.fromJson(x))),
      );
}
