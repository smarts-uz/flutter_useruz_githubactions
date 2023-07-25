import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

class ErrorModel {
  ErrorModel({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    success: json["success"] ?? false,
    message: json["message"] ?? true,
  );
}
