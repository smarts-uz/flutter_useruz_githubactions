// To parse this JSON data, do
//
//     final modelAllFavoriteTask = modelAllFavoriteTaskFromJson(jsonString);

import 'dart:convert';

ModelAllFavoriteTask modelAllFavoriteTaskFromJson(String str) => ModelAllFavoriteTask.fromJson(json.decode(str));

String modelAllFavoriteTaskToJson(ModelAllFavoriteTask data) => json.encode(data.toJson());

class ModelAllFavoriteTask {
    List<Datum> data;
    Links links;
    Meta meta;

    ModelAllFavoriteTask({
        required this.data,
        required this.links,
        required this.meta,
    });

    factory ModelAllFavoriteTask.fromJson(Map<String, dynamic> json) => ModelAllFavoriteTask(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
    };
}

class Datum {
    int id;
    int userId;
    Task task;

    Datum({
        required this.id,
        required this.userId,
        required this.task,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        task: Task.fromJson(json["task"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "task": task.toJson(),
    };
}

class Task {
    int id;
    String name;
    List<Address> addresses;
    DateTime startDate;
    DateTime? endDate;
    int budget;
    dynamic remote;
    String oplata;
    int status;
    String categoryIcon;
    bool viewed;

    Task({
        required this.id,
        required this.name,
        required this.addresses,
        required this.startDate,
        this.endDate,
        required this.budget,
        this.remote,
        required this.oplata,
        required this.status,
        required this.categoryIcon,
        required this.viewed,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
        startDate: DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        budget: json["budget"],
        remote: json["remote"],
        oplata: json["oplata"],
        status: json["status"],
        categoryIcon: json["category_icon"],
        viewed: json["viewed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "start_date": startDate.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "budget": budget,
        "remote": remote,
        "oplata": oplata,
        "status": status,
        "category_icon": categoryIcon,
        "viewed": viewed,
    };
}

class Address {
    String location;
    double longitude;
    double latitude;

    Address({
        required this.location,
        required this.longitude,
        required this.latitude,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        location: json["location"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "location": location,
        "longitude": longitude,
        "latitude": latitude,
    };
}

class Links {
    String first;
    String last;
    dynamic prev;
    dynamic next;

    Links({
        required this.first,
        required this.last,
        this.prev,
        this.next,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    int currentPage;
    int from;
    int lastPage;
    List<Link> links;
    String path;
    int perPage;
    int to;
    int total;

    Meta({
        required this.currentPage,
        required this.from,
        required this.lastPage,
        required this.links,
        required this.path,
        required this.perPage,
        required this.to,
        required this.total,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
