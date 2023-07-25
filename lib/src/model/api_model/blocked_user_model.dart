class AllBlockedusersModel {
  AllBlockedusersModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<BlockedUsersListItemModel> data;

  factory AllBlockedusersModel.fromJson(Map<String, dynamic> json) =>
      AllBlockedusersModel(
        success: json['success'] ?? false,
        data: json["data"] == null
            ? <BlockedUsersListItemModel>[]
            : List<BlockedUsersListItemModel>.from(
                json["data"].map(
                  (x) => BlockedUsersListItemModel.fromJson(x),
                ),
              ),
      );
}

class BlockedUsersListItemModel {
  BlockedUsersListItemModel({
    required this.id,
    required this.userid,
    required this.blockeduser,
  });

  int id;
  int userid;
  BlockedUserModel blockeduser;

  factory BlockedUsersListItemModel.fromJson(Map<String, dynamic> json) =>
      BlockedUsersListItemModel(
          id: json['id'] ?? 0,
          userid: json['user_id'] ?? 0,
          blockeduser: json['blocked_user'] != null
              ? BlockedUserModel.fromJson(json['blocked_user'])
              : BlockedUserModel.fromJson({}));
}

class BlockedUserModel {
  BlockedUserModel({
    required this.id,
    required this.name,
    required this.lastSeen,
    required this.avatar,
  });

  int id;
  String name;
  String lastSeen;
  String avatar;

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) =>
      BlockedUserModel(
          id: json['id'] ?? 0,
          name: json['name'] ?? '',
          lastSeen: json['last_seen'] ?? '',
          avatar: json['avatar'] ?? '');
}
