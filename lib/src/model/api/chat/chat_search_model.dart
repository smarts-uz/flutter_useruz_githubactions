class SearchChatModel {
  SearchChatModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<SearchResult> data;
  String message;

  factory SearchChatModel.fromJson(Map<String, dynamic> json) =>
      SearchChatModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? <SearchResult>[]
            : List<SearchResult>.from(
                json["data"].map((x) => SearchResult.fromJson(x))),
        message: json["message"] ?? "",
      );
}

class SearchResult {
  SearchResult({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.avatar,
  });

  int id;
  String name;
  int activeStatus;
  String avatar;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        activeStatus: json["active_status"] ?? 0,
        avatar: json["avatar"] ?? "",
      );
}
