// To parse this JSON data, do
//
//     final modelCreateFavoriteTask = modelCreateFavoriteTaskFromJson(jsonString);

import 'dart:convert';

ModelCreateFavoriteTask modelCreateFavoriteTaskFromJson(String str) => ModelCreateFavoriteTask.fromJson(json.decode(str));

String modelCreateFavoriteTaskToJson(ModelCreateFavoriteTask data) => json.encode(data.toJson());

class ModelCreateFavoriteTask {
    bool success;
    String message;

    ModelCreateFavoriteTask({
        required this.success,
        required this.message,
    });

    factory ModelCreateFavoriteTask.fromJson(Map<String, dynamic> json) => ModelCreateFavoriteTask(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
