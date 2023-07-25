class AllCategoriesChildsModel {
  AllCategoriesChildsModel({
    required this.childs,
  });

  List<int> childs;

  factory AllCategoriesChildsModel.fromJson(Map<String, dynamic> json) =>
      AllCategoriesChildsModel(
        childs: json["data"] == null
            ? List<int>.from(<int>[])
            : List<int>.from(json["data"]),
      );
}
