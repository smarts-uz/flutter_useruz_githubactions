class TasksModel {
  TasksModel({
    required this.data,
    required this.lastPage,
    required this.total,
  });

  List<TaskModelResult> data;
  int lastPage;
  int total;

  factory TasksModel.fromJson(Map<String, dynamic> json) {
    int lastPage = 0;
    int total = 0;
    try {
      lastPage = json["last_page"] ?? 0;
      total = json["total"] ?? 0;
    } catch (_) {}
    return TasksModel(
      data: json["data"] == null
          ? <TaskModelResult>[]
          : List<TaskModelResult>.from(
              json["data"].map((x) => TaskModelResult.fromJson(x))),
      lastPage: lastPage,
      total: total,
    );
  }
}

class TaskModelResult {
  TaskModelResult({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.addresses,
    required this.budget,
    required this.oplata,
    required this.categoryIcon,
    required this.viewed,
  });

  int id;
  String name;
  List<Address> addresses;
  String startDate;
  String endDate;
  int budget;
  String oplata;
  String categoryIcon;
  bool viewed;

  factory TaskModelResult.fromJson(Map<String, dynamic> json) =>
      TaskModelResult(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        addresses: json["addresses"] == null
            ? <Address>[Address.fromJson({})]
            : List<Address>.from(
                json["addresses"].map(
                  (x) => Address.fromJson(x),
                ),
              ),
        budget: json["budget"] ?? 0,
        oplata: json["oplata"] ?? "0",
        viewed: json["viewed"] ?? false,
        categoryIcon: json["category_icon"] ?? "",
      );
}

class Address {
  Address({
    required this.latitude,
    required this.location,
    required this.longitude,
  });

  double latitude;
  String location;
  double longitude;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        latitude: json["latitude"] ?? 0,
        location: json["location"] ?? "",
        longitude: json["longitude"] ?? 0,
      );
}
