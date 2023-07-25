class ChangeImageModel {
  ChangeImageModel({
    required this.success,
  });

  bool success;

  factory ChangeImageModel.fromJson(Map<String, dynamic> json) =>
      ChangeImageModel(
        success: json["success"] ?? false,
      );
}
