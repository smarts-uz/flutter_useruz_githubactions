import 'dart:io';

class ChatMessageModel {
  ChatMessageModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<ChatMessageResult> data;
  String message;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? <ChatMessageResult>[]
            : List<ChatMessageResult>.from(
                json["data"].map((x) => ChatMessageResult.fromJson(x))),
        message: json["message"] ?? '',
      );
}

class ChatMessageResult {
  ChatMessageResult({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.message,
    required this.attachment,
    required this.seen,
    required this.createdAt,
    this.file,
  });

  int id;
  int fromId;
  int toId;
  String message;
  Attachment attachment;
  int seen;
  File? file;
  DateTime createdAt;

  factory ChatMessageResult.fromJson(Map<String, dynamic> json) {
    return ChatMessageResult(
      id: json["id"] ?? 0,
      fromId: json["from_id"] ?? 0,
      toId: json["to_id"] ?? 0,
      message: json["message"] ?? "",
      attachment:
          Attachment.fromJson(json["attachment"]) ?? Attachment.fromJson({}),
      seen: json["seen"] ?? 0,
      createdAt: json["created_at"] == null
          ? DateTime.now()
          : DateTime.parse(json["created_at"]),
    );
  }
}

class Attachment {
  Attachment({
    required this.path,
    required this.type,
  });

  String path;
  String type;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        path: json["path"] ?? "",
        type: json["type"] ?? "",
      );
}
