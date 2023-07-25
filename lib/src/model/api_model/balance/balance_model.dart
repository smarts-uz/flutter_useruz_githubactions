class BalanceModel {
  BalanceModel({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.balance,
    required this.transaction,
  });

  int balance;
  Transaction transaction;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        balance: json["balance"] ?? 0,
        transaction: json["transaction"] == null
            ? Transaction.fromJson({})
            : Transaction.fromJson(json["transaction"]),
      );
}

class Transaction {
  Transaction({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<Datum> data;
  Links links;
  Meta meta;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        data: json["data"] == null
            ? List<Datum>.from({})
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links(
          first: json['first_page_url'] ?? '',
          last: json['last_page_url'] ?? '',
        ),
        // json["links"] == null
        //     ? Links.fromJson({})
        //     : Links.fromJson(json["links"]),
        meta: Meta(
          currentPage: json["current_page"] ?? 0,
          from: json["from"] ?? 0,
          lastPage: json["last_page"] ?? 0,
          links: json["links"] == null
              ? List<Link>.from({})
              : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
          path: json["path"] ?? "",
          perPage: json["per_page"] ?? 0,
          to: json["to"] ?? 0,
          total: json["total"] ?? 0,
        ),
        // json["meta"] == null
        //     ? Meta.fromJson({})
        //     : Meta.fromJson(json["meta"]),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.method,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.state,
  });

  int id;
  int userId;
  String method;
  int amount;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int state;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        method: json["method"] ?? "",
        amount: json["amount"] ?? 0,
        status: json["status"] ?? 0,
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["updated_at"]),
        state: json["state"] ?? 0,
      );
}

class Links {
  Links({
    required this.first,
    required this.last,
  });

  String first;
  String last;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"] ?? "",
        last: json["last"] ?? "",
      );
}

class Meta {
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

  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"] ?? 0,
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        links: json["links"] == null
            ? List<Link>.from({})
            : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
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
