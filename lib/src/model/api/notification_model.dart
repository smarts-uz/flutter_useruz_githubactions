class NotificationModel {
  NotificationModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<NotificationResult> data;
  String message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? <NotificationResult>[]
            : List<NotificationResult>.from(
                json["data"].map((x) => NotificationResult.fromJson(x))),
        message: json["message"] ?? "",
      );
}

class NotificationCountModel {
  NotificationCountModel({
    required this.success,
    required this.count,
  });

  bool success;
  int count;

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) =>
      NotificationCountModel(
        success: json["success"] ?? false,
        count: json["data"]["count"] ?? 0,
      );
}

class NotificationResult {
  NotificationResult({
    required this.id,
    required this.title,
    required this.type,
    required this.taskId,
    required this.taskName,
    required this.userId,
    required this.isRead,
    required this.userName,
    required this.createdAt,
  });

  int id;
  String title;
  int type;
  int taskId;
  String taskName;
  int userId;
  int isRead;
  String userName;
  String createdAt;

  factory NotificationResult.fromJson(Map<String, dynamic> json) =>
      NotificationResult(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        type: json["type"] ?? 0,
        taskId: json["task_id"] ?? 0,
        isRead: json["is_read"] ?? 0,
        taskName: json["task_name"] ?? "",
        userId: json["user_id"] ?? 0,
        userName: json["user_name"] ?? "",
        createdAt: json["created_at"] ?? "",
      );
}
