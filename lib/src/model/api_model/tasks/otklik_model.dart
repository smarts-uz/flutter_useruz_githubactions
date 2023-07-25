import 'package:youdu/src/model/api_model/profile/my_task_model.dart';

class OtklikModel {
  OtklikModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<Datum> data;
  Links links;
  Meta meta;

  factory OtklikModel.fromJson(Map<String, dynamic> json) => OtklikModel(
        data: json["data"] == null
            ? List<Datum>.from(<Datum>[])
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links(
          first: json['first_page_url'] ?? '',
          last: json['last_page_url'] ?? '',
          prev: json['prev_page_url'] ?? '',
          next: json['next_page_url'] ?? '',
        ),
        // json["links"] == null
        //     ? Links.fromJson({})
        //     : Links.fromJson(json["links"]),
        meta: Meta(
          currentPage: json['current_page'] ?? 0,
          from: json['from'] ?? 0,
          lastPage: json['last_page'] ?? 0,
          path: json['path'] ?? "",
          perPage: json['per_page'] ?? 0,
          to: json['to'] ?? 0,
          total: json['total'] ?? 0,
        ),
        // json["meta"] == null
        //     ? Meta.fromJson({})
        //     : Meta.fromJson(json["meta"]),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.user,
    required this.budget,
    required this.description,
    required this.createdAt,
    required this.notFree,
  });

  int id;
  User user;
  int budget;
  String description;
  String createdAt;
  int notFree;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        user: json["user"] == null
            ? User.fromJson({})
            : User.fromJson(json["user"]),
        budget: json["budget"] ?? 0,
        description: json["description"] ?? "",
        createdAt: json["created_at"] ?? "",
        notFree: json["not_free"] ?? 0,
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phoneNumber,
    required this.degree,
    required this.likes,
    required this.dislikes,
    required this.stars,
    required this.lastSeen,
  });

  int id;
  String name;
  String avatar;
  String phoneNumber;
  String degree;
  int likes;
  int dislikes;
  int stars;
  String lastSeen;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        avatar: json["avatar"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        degree: json["degree"] ?? "",
        likes: json["likes"] ?? 0,
        dislikes: json["dislikes"] ?? 0,
        stars: json["stars"] ?? 0,
        lastSeen: json["last_seen"] ?? "",
      );
}

class User1 {
  User1({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phoneNumber,
    required this.degree,
    required this.likes,
    required this.dislikes,
    required this.stars,
    required this.lastSeen,
    required this.description,
    required this.price,
    required this.createdAt,
  });

  int id;
  String name;
  String avatar;
  String phoneNumber;
  String degree;
  int likes;
  int dislikes;
  int stars;
  String lastSeen;
  String description;
  int price;
  String createdAt;

  factory User1.fromJson(Map<String, dynamic> json) => User1(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        avatar: json["avatar"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        degree: json["degree"] ?? "",
        likes: json["likes"] ?? 0,
        dislikes: json["dislikes"] ?? 0,
        stars: json["stars"] ?? 0,
        lastSeen: json["last_seen"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? 0,
        createdAt: json["created_at"] ?? "",
      );
}
