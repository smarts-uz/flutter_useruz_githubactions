import 'dart:convert';

import 'package:youdu/src/model/api_model/profile/my_task_model.dart';

AllPerformersModel allPerformersModelFromJson(String str) =>
    AllPerformersModel.fromJson(json.decode(str));

class AllPerformersModel {
  AllPerformersModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<PerformersModel> data;
  Links links;
  Meta meta;

  factory AllPerformersModel.fromJson(Map<String, dynamic> json) =>
      AllPerformersModel(
        data: json["data"] == null
            ? <PerformersModel>[]
            : List<PerformersModel>.from(
                json["data"].map((x) => PerformersModel.fromJson(x))),
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

class PerformersModel {
  PerformersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    required this.location,
    required this.lastSeen,
    required this.likes,
    required this.dislikes,
    required this.description,
    required this.stars,
  });

  int id;
  String name;
  String email;
  String avatar;
  String phoneNumber;
  String location;
  String lastSeen;
  int likes;
  int dislikes;
  String description;
  int stars;

  factory PerformersModel.fromJson(Map<String, dynamic> json) =>
      PerformersModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        avatar: json["avatar"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        location: json["location"] ?? "",
        lastSeen: json["last_seen"] ?? "",
        likes: json["likes"] ?? 0,
        dislikes: json["dislikes"] ?? 0,
        description: json["description"] ?? "",
        stars: json["stars"] ?? 0,
      );
}
