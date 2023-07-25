import 'package:youdu/src/utils/utils.dart';

class SettingsDataModel {
  SettingsDataModel({
    required this.data,
  });

  Data data;

  factory SettingsDataModel.fromJson(Map<String, dynamic> json) =>
      SettingsDataModel(
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.name,
    required this.lastName,
    required this.avatar,
    required this.location,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.phone,
  });

  String name;
  String lastName;
  String avatar;
  String location;
  DateTime? dateOfBirth;
  String email;
  String phone;
  int gender;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"] ?? "",
        lastName: json["last_name"] ?? "",
        avatar: json["avatar"] ?? "",
        location: json["location"] ?? "",
        phone: json["phone"] ?? "",
        gender: json["gender"] ?? 0,
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime(
                int.parse(json["date_of_birth"].toString().split("-").first),
                int.parse(Utils.numberFormat(int.parse(json["date_of_birth"]
                    .toString()
                    .split(
                        "${json["date_of_birth"].toString().split("-").first}-")
                    .last
                    .split("-")
                    .first))),
                int.parse(Utils.numberFormat(int.parse(json["date_of_birth"]
                    .toString()
                    .split("-")
                    .last
                    .split("-")
                    .last)))),
        email: json["email"] ?? "",
      );
}
