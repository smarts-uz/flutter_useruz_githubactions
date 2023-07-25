class MyTaskCountModel {
  MyTaskCountModel({
    required this.success,
    required this.data,
    this.load = false,
  });

  bool success;
  bool load;
  Data data;

  factory MyTaskCountModel.fromJson(Map<String, dynamic> json) =>
      MyTaskCountModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data(
      {required this.openTasks,
      required this.inProcessTasks,
      required this.completeTasks,
      required this.cancelledTasks,
      required this.all,
      required this.withoutReviews});

  All openTasks;
  All inProcessTasks;
  All completeTasks;
  All cancelledTasks;
  All all;
  All withoutReviews;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        openTasks: json["open_tasks"] == null
            ? All.fromJson({})
            : All.fromJson(json["open_tasks"]),
        inProcessTasks: json["in_process_tasks"] == null
            ? All.fromJson({})
            : All.fromJson(json["in_process_tasks"]),
        completeTasks: json["complete_tasks"] == null
            ? All.fromJson({})
            : All.fromJson(json["complete_tasks"]),
        cancelledTasks: json["cancelled_tasks"] == null
            ? All.fromJson({})
            : All.fromJson(json["cancelled_tasks"]),
        all: json["all"] == null ? All.fromJson({}) : All.fromJson(json["all"]),
        withoutReviews: json["without_reviews"] == null
            ? All.fromJson({})
            : All.fromJson(json["without_reviews"]),
      );
}

class All {
  All({
    required this.count,
    required this.status,
  });

  int count;
  int status;

  factory All.fromJson(Map<String, dynamic> json) => All(
        count: json["count"] ?? 0,
        status: json["status"] ?? 0,
      );
}
