class ReviewModel {
  ReviewModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<ReviewData> data;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? <ReviewData>[]
            : List<ReviewData>.from(
                json["data"].map((x) => ReviewData.fromJson(x))),
      );
}

class ReviewData {
  ReviewData({
    required this.id,
    required this.user,
    required this.description,
    required this.goodBad,
    required this.task,
    required this.createdAt,
  });

  int id;
  User user;
  String description;
  int goodBad;
  Task task;
  DateTime createdAt;

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"] ?? 0,
        user: json["user"] == null
            ? User.fromJson({})
            : User.fromJson(json["user"]),
        description: json["description"] ?? "",
        goodBad: json["good_bad"] ?? 0,
        task: json["task"] == null
            ? Task.fromJson({})
            : Task.fromJson(json["task"]),
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
      );
}

class Task {
  Task({
    required this.name,
    required this.description,
  });

  String name;
  String description;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json["name"] ?? "",
        description: json["description"] ?? "",
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.lastSeen,
    required this.reviewGood,
    required this.reviewBad,
    required this.rating,
    required this.avatar,
  });

  int id;
  String name;
  String lastSeen;
  int reviewGood;
  int reviewBad;
  int rating;
  String avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        lastSeen: json["last_seen"] ?? "",
        reviewGood: json["review_good"] ?? 0,
        reviewBad: json["review_bad"] ?? 0,
        rating: json["rating"] ?? 0,
        avatar: json["avatar"] ?? "",
      );
}
