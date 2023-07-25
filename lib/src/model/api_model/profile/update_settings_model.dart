class UpdateSettingsModel {
  UpdateSettingsModel({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory UpdateSettingsModel.fromJson(Map<String, dynamic> json) =>
      UpdateSettingsModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.message,
  });

  String message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"] ?? "",
      );
}
