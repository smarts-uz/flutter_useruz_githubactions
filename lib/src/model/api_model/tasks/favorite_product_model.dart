import 'dart:convert';

import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/favorite_tasks_model.dart';
import 'package:youdu/src/model/api_model/tasks/same_task_model.dart';

import 'otklik_model.dart';

FavoriteProductModel favoriteproductModelFromJson(String str) =>
    FavoriteProductModel.fromJson(json.decode(str));

class FavoriteProductModel {
  FavoriteProductModel({
    required this.data,
  });

  FavoriteTaskModel data;

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) => FavoriteProductModel(
    data: json["data"] == null
        ? FavoriteTaskModel.fromJson({})
        : FavoriteTaskModel.fromJson(json["data"]),
  );
}

class FavoriteTaskModel {
  FavoriteTaskModel({
    required this.id,
    required this.name,
    required this.address,
    required this.dateType,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.description,
    required this.phone,
    required this.performerId,
    required this.categoryName,
    required this.user,
    required this.views,
    required this.status,
    required this.pay,
    required this.docs,
    required this.createdAt,
    required this.customFields,
    required this.photos,
    required this.currentUserResponse,
    required this.responsesCount,
    required this.categoryId,
    required this.performer,
    required this.responsePrice,
    required this.freeResponse,
    required this.performerReview,
    required this.parentCategoryName,
    required this.other,
    this.sameData = const [],
    this.isMine = false,
  });

  bool isMine;
  int id;
  String name;
  List<Address> address;
  int dateType;
  DateTime startDate;
  DateTime endDate;
  int budget;
  String description;
  String phone;
  String parentCategoryName;
  bool other;

  //int performerId;
  String categoryName;
  int categoryId;
  User user;
  int views;
  int status;
  int responsesCount;
  String pay;
  int docs;
  String createdAt;
  List<CreateRouteCustomField> customFields;
  List<String> photos;
  bool currentUserResponse;
  List<SameTaskModel> sameData;
  int performerId;
  User1 performer;
  String responsePrice;
  String freeResponse;
  int performerReview;

  factory FavoriteTaskModel.fromJson(Map<String, dynamic> json) => FavoriteTaskModel(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    address: json["address"] == null
        ? List<Address>.from(<Address>[])
        : List<Address>.from(
        json["address"].map((x) => Address.fromJson(x))),
    dateType: json["date_type"] ?? 0,
    categoryId: json["category_id"] ?? 0,
    responsesCount: json["responses_count"] ?? 0,
    startDate: json["start_date"] == null
        ? DateTime.now()
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null
        ? DateTime.now()
        : DateTime.parse(json["end_date"]),
    budget: json["budget"] ?? 0,
    description: json["description"] ?? "",
    phone: json["phone"] ?? "",
    performerId: json["performer_id"] ?? 0,
    categoryName: json["category_name"] ?? "",
    user: json["user"] == null
        ? User.fromJson({})
        : User.fromJson(json["user"]),
    views: json["views"] ?? 0,
    status: json["status"] ?? 0,
    pay: json["oplata"] ?? "0",
    responsePrice: json["response_price"] ?? "0",
    freeResponse: json["free_response"] ?? "0",
    currentUserResponse: json["current_user_response"] ?? false,
    docs: json["docs"] ?? 0,
    performerReview: json["performer_review"] ?? 0,
    createdAt: json["created_at"] ?? "",
    customFields: json["custom_fields"] == null
        ? <CreateRouteCustomField>[]
        : List<CreateRouteCustomField>.from(json["custom_fields"]
        .map((x) => CreateRouteCustomField.fromJson(x))),
    photos: json["photos"] == null
        ? []
        : List<String>.from(json["photos"].map((x) => x)),
    performer: json["performer"] == null
        ? User1.fromJson({})
        : User1.fromJson(json["performer"]),
    other: json["other"] ?? false,
    parentCategoryName: json["parent_category_name"] ?? "",
  );
}