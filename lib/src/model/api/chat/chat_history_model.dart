class ChatHistoryModel {
  ChatHistoryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  ChatHistoryData data;
  String message;

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? ChatHistoryData.fromJson({})
            : ChatHistoryData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class ChatHistoryData {
  ChatHistoryData({
    required this.contacts,
  });

  List<CharHistoryResult> contacts;

  factory ChatHistoryData.fromJson(Map<String, dynamic> json) =>
      ChatHistoryData(
        contacts: json["contacts"] == null
            ? <CharHistoryResult>[]
            : List<CharHistoryResult>.from(
                json["contacts"].map((x) => CharHistoryResult.fromJson(x))),
      );
}

class CharHistoryResult {
  CharHistoryResult({
    required this.user,
    required this.lastMessage,
    required this.unseenCounter,
  });

  User user;
  List<LastMessageData> lastMessage;
  int unseenCounter;

  factory CharHistoryResult.fromJson(Map<String, dynamic> json) {
    List<LastMessageData> data = [LastMessageData.fromJson({})];
    try {
      data = List<LastMessageData>.from(
          json["lastMessage"].map((x) => LastMessageData.fromJson(x)));
    } catch (_) {}
    return CharHistoryResult(
      user: json["user"] == null
          ? User.fromJson({})
          : User.fromJson(json["user"]),
      lastMessage: data,
      unseenCounter: json["unseenCounter"] ?? 0,
    );
  }
}

class LastMessageData {
  LastMessageData({
    required this.id,
    required this.type,
    required this.fromId,
    required this.toId,
    required this.body,
    required this.seen,
    required this.createdAt,
  });

  int id;
  String type;
  int fromId;
  int toId;
  String body;
  int seen;
  DateTime createdAt;

  factory LastMessageData.fromJson(Map<String, dynamic> json) =>
      LastMessageData(
        id: json["id"] ?? 0,
        type: json["type"] ?? "",
        fromId: json["from_id"] ?? 0,
        toId: json["to_id"] ?? 0,
        body: json["message"] ?? "",
        seen: json["seen"] ?? 0,
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.avatar,
    required this.lastSeen,
  });

  int id;
  String name;
  int activeStatus;
  String avatar;
  String lastSeen;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      activeStatus: json["active_status"] ?? 0,
      avatar: json["avatar"] ?? "",
      lastSeen: json["last_seen"] ?? "");
}
