class FacebookUserModel {
  final String? email;
  final String? id;
  final String? name;
  final PictureModel? pictureModel;

  FacebookUserModel({
    this.name,
    this.pictureModel,
    this.email,
    this.id,
  });

  factory FacebookUserModel.fromJson(Map<String, dynamic> json) =>
      FacebookUserModel(
        email: json["email"] ?? "",
        id: json["id"] as String? ?? "",
        name: json["name"] ?? "",
        pictureModel: json["picture"]["data"] == null
            ? PictureModel.fromJson({})
            : PictureModel.fromJson(json["picture"]["data"]),
      );
}

class PictureModel {
  final String? url;
  final int? width;
  final int? height;

  PictureModel({
    this.width,
    this.height,
    this.url,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        url: json["url"] ?? "",
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
      );
}
