class RegistrationErrorModel {
  RegistrationErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  bool success;
  String message;
  Errors errors;

  factory RegistrationErrorModel.fromJson(Map<String, dynamic> json) =>
      RegistrationErrorModel(
        success: json["success"] ?? "",
        message: json["message"] ?? "",
        errors: json["errors"] == null
            ? Errors.fromJson({})
            : Errors.fromJson(json["errors"]),
      );
}

class Errors {
  Errors({
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  String email;
  String phoneNumber;
  String password;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        email: json["email"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        password: json["password"] ?? "",
      );
}
