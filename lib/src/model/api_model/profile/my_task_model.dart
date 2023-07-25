import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';

class MyTaskModel {
  MyTaskModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.prevPageUrl,
    required this.nextPageUrl,
    required this.links,
    required this.meta,
  });

  List<TaskModelResult> data;
  int currentPage;
  int lastPage;
  int total;
  String prevPageUrl;
  String nextPageUrl;
  Links links;
  Meta meta;

  factory MyTaskModel.fromJson(Map<String, dynamic> json) => MyTaskModel(
        data: json["data"] == null
            ? List<TaskModelResult>.from(<TaskModelResult>[])
            : List<TaskModelResult>.from(
                json["data"].map((x) => TaskModelResult.fromJson(x))),
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        total: json["total"] ?? 0,
        prevPageUrl: json["prev_page_url"] ?? "",
        nextPageUrl: json["next_page_url"] ?? "",
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

class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  String first;
  String last;
  String prev;
  String next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"] ?? "",
        last: json["last"] ?? "",
        prev: json["prev"] ?? "",
        next: json["next"] ?? "",
      );
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"] ?? 0,
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 0,
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
      );
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? "",
        label: json["label"] ?? "",
        active: json["active"] ?? false,
      );
}
