class AllSupporGuidesModel {
  AllSupporGuidesModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<SupportGuideModel> data;

  factory AllSupporGuidesModel.fromJson(Map<String, dynamic> json) =>
      AllSupporGuidesModel(
        success: json['success'] ?? false,
        data: json["data"] == null
            ? <SupportGuideModel>[]
            : List<SupportGuideModel>.from(
                json["data"].map(
                  (x) => SupportGuideModel.fromJson(x),
                ),
              ),
      );
}

class SupportGuideModel {
  SupportGuideModel({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory SupportGuideModel.fromJson(Map<String, dynamic> json) =>
      SupportGuideModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
      );
}

class GuideItemModel {
  GuideItemModel({
    required this.id,
    required this.title,
    required this.logo,
    required this.description,
  });

  int id;
  String title;
  String logo;
  String description;

  factory GuideItemModel.fromJson(Map<String, dynamic> json) => GuideItemModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        logo: json['logo'] ?? '',
        description: json['description'] ?? '',
      );
}
