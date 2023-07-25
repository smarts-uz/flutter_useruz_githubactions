class LoginModel {
  LoginModel({
    required this.user,
    required this.accessToken,
    required this.socialpas,
  });

  User user;
  String accessToken;
  bool socialpas;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        user: json["user"] == null
            ? User.fromJson({})
            : User.fromJson(json["user"]),
        accessToken: json["access_token"] ?? "",
        socialpas: json["socialpas"] ?? false,
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.balance,
    required this.roleId,
    required this.emailVerified,
    required this.phoneVerified,
  });

  int id;
  String name;
  bool emailVerified;
  bool phoneVerified;
  String email;
  String phoneNumber;
  String avatar;
  int balance;
  int roleId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        avatar: json["avatar"] ?? "",
        balance: json["balance"] ?? 0,
        roleId: json["role_id"] ?? 0,
        phoneVerified: json["phone_verified"] ?? false,
        emailVerified: json["email_verified"] ?? false,
      );
}
