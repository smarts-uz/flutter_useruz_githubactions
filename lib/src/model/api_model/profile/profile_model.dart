import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/utils/utils.dart';

class ProfileModel {
  ProfileModel({
    required this.data,
  });

  Data data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.tasksCount,
    required this.achievements,
    required this.phoneNumber,
    required this.location,
    required this.district,
    required this.age,
    required this.description,
    required this.workExp,
    required this.categoryId,
    required this.emailVerified,
    required this.phoneVerified,
    required this.googleId,
    required this.facebookId,
    required this.bornDate,
    required this.createdTasks,
    required this.performedTasks,
    required this.reviews,
    required this.phoneNumberOld,
    required this.systemNotification,
    required this.newsNotification,
    required this.portfolios,
    required this.views,
    required this.walletBalance,
    required this.lastSeen,
    required this.video,
    required this.categories,
    required this.createdAt,
    required this.activeTask,
    required this.taskStep,
    required this.blockedUser,
    required this.exampleCount,
    required this.lastVersion,
    required this.notificationOff,
    required this.notificationFrom,
    required this.notificationTo,
  });

  int id;
  String name;
  String lastName;
  String email;
  String avatar;
  List<TasksCount> tasksCount;
  List<Achievement> achievements;
  String phoneNumber;
  String location;
  String district;
  String video;
  int age;
  int activeTask;
  int taskStep;
  String description;
  int workExp;
  String categoryId;
  bool emailVerified;
  bool phoneVerified;
  String googleId;
  String facebookId;
  DateTime bornDate;
  int createdTasks;
  int performedTasks;
  Reviews reviews;
  String phoneNumberOld;
  String systemNotification;
  String newsNotification;
  List<Portfolio> portfolios;
  int views;
  int walletBalance;
  String lastSeen;
  List<CategoryModel> categories;
  DateTime createdAt;
  int blockedUser;
  int exampleCount;
  String lastVersion;
  String notificationOff;
  String notificationFrom;
  String notificationTo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        lastName: json["last_name"] ?? "",
        email: json["email"] ?? "",
        avatar: json["avatar"] ?? "",
        tasksCount: json["tasks_count"] == null
            ? List<TasksCount>.from(<TasksCount>[])
            : List<TasksCount>.from(
                json["tasks_count"].map((x) => TasksCount.fromJson(x))),
        achievements: json["achievements"] == null
            ? List<Achievement>.from(<Achievement>[])
            : List<Achievement>.from(
                json["achievements"].map((x) => Achievement.fromJson(x))),
        phoneNumber: json["phone_number"] ?? "",
        location: json["location"] ?? "",
        categories: json["categories"] == null
            ? <CategoryModel>[]
            : List<CategoryModel>.from(
                json["categories"].map((x) => CategoryModel.fromJson(x))),
        district: json["district"] ?? "",
        age: json["age"] ?? 0,
        description: json["description"] ?? "",
        workExp: json["work_experience"] ?? 0,
        categoryId: json["category_id"] ?? "",
        emailVerified: json["email_verified"] ?? false,
        phoneVerified: json["phone_verified"] ?? false,
        googleId: json["google_id"] ?? "",
        video: json["video"] ?? "",
        facebookId: json["facebook_id"] ?? "",
        bornDate: json["born_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["born_date"]),
        createdTasks: json["created_tasks"] ?? 0,
        performedTasks: json["performed_tasks"] ?? 0,
        reviews: json["reviews"] == null
            ? Reviews.fromJson({})
            : Reviews.fromJson(json["reviews"]),
        phoneNumberOld: json["phone_number_old"] ?? "",
        systemNotification: json["system_notification"] ?? "",
        newsNotification: json["news_notification"] ?? "",
        portfolios: json["portfolios"] == null
            ? List<Portfolio>.from(<Portfolio>[])
            : List<Portfolio>.from(
                json["portfolios"].map((x) => Portfolio.fromJson(x))),
        views: json["views"] ?? 0,
        walletBalance: json["wallet_balance"] ?? 0,
        lastSeen: json["last_seen"] ?? "",
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        activeTask: json["active_task"] ?? 1,
        taskStep: json["active_step"] ?? 1,
        blockedUser: json["blocked_user"] ?? 0,
        exampleCount: json["portfolios_count"] ?? 0,
        lastVersion: json["last_version"] ?? Utils.currentVersion,
        notificationOff: json["notification_off"] ?? "",
        notificationFrom: json["notification_from"] ?? "",
        notificationTo: json["notification_to"] ?? "",
      );
}

class Achievement {
  Achievement({
    required this.image,
    required this.message,
  });

  String image;
  String message;

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        image: json["image"] ?? "",
        message: json["message"] ?? "",
      );
}

class Portfolio {
  Portfolio({
    required this.id,
    required this.userId,
    required this.comment,
    required this.images,
  });

  int id;
  int userId;
  String comment;
  List<String> images;

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        comment: json["comment"] ?? "",
        images: json["images"] == null
            ? List<String>.from(<String>[])
            : List<String>.from(json["images"].map((x) => x)),
      );
}

class Reviews {
  Reviews({
    required this.reviewBad,
    required this.reviewGood,
    required this.rating,
    required this.lastReview,
  });

  int reviewBad;
  int reviewGood;
  int rating;
  LastReview lastReview;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        reviewBad: json["review_bad"] ?? 0,
        reviewGood: json["review_good"] ?? 0,
        rating: json["rating"] ?? 0,
        lastReview: json["last_review"] == null
            ? LastReview.fromJson({})
            : LastReview.fromJson(json["last_review"]),
      );
}

class LastReview {
  LastReview({
    required this.description,
    required this.reviewerName,
  });

  String description;
  String reviewerName;

  factory LastReview.fromJson(Map<String, dynamic> json) => LastReview(
        description: json["description"] ?? "",
        reviewerName: json["reviewer_name"] ?? "",
      );
}

class TasksCount {
  TasksCount({
    required this.name,
    required this.tasksCountSub,
  });

  String name;
  List<TasksCountSub> tasksCountSub;

  factory TasksCount.fromJson(Map<String, dynamic> json) => TasksCount(
        name: json["name"] ?? "",
        tasksCountSub: json["childs"]
            .map<TasksCountSub>((e) => TasksCountSub.fromJson(e))
            .toList(),
      );
}

class TasksCountSub {
  String name;
  num taskCount;
  TasksCountSub({
    required this.name,
    required this.taskCount,
  });
  factory TasksCountSub.fromJson(Map<String, dynamic> json) => TasksCountSub(
        name: json["name"] ?? "",
        taskCount: json["task_count"] ?? 0,
      );
}
