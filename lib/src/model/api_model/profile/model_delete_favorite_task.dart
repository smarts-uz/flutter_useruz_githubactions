// To parse this JSON data, do
//
//     final modelDeleteFavoriteTask = modelDeleteFavoriteTaskFromJson(jsonString);

import 'dart:convert';

ModelDeleteFavoriteTask modelDeleteFavoriteTaskFromJson(String str) => ModelDeleteFavoriteTask.fromJson(json.decode(str));

String modelDeleteFavoriteTaskToJson(ModelDeleteFavoriteTask data) => json.encode(data.toJson());

class ModelDeleteFavoriteTask {
    bool success;
    String message;

    ModelDeleteFavoriteTask({
        required this.success,
        required this.message,
    });

    factory ModelDeleteFavoriteTask.fromJson(Map<String, dynamic> json) => ModelDeleteFavoriteTask(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
