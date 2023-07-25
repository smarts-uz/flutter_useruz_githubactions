class SupportNumberModel {
  SupportNumberModel({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory SupportNumberModel.fromJson(Map<String, dynamic> json) =>
      SupportNumberModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"][0]),
      );
}

class Data {
  Data({
    required this.supportNumber,
  });

  String supportNumber;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        supportNumber: json["value"] ?? "",
      );
}
