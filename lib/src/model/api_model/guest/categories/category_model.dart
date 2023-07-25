class AllCategoryModel {
  AllCategoryModel({
    required this.data,
  });

  List<CategoryModel> data;

  factory AllCategoryModel.fromJson(Map<String, dynamic> json) =>
      AllCategoryModel(
        data: json["data"] == null
            ? <CategoryModel>[]
            : List<CategoryModel>.from(
                json["data"].map((x) => CategoryModel.fromJson(x))),
      );
}

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.parentId,
    required this.childCount,
    required this.name,
    required this.ico,
    this.selectedItem = true,
  });

  int id;
  int parentId;
  int childCount;
  String name;
  String ico;
  bool selectedItem;
  List<CategoryModel> chooseItem = [];

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? 0,
        parentId: json["parent_id"] ?? 0,
        childCount: json["child_count"] ?? 0,
        name: json["name"] ?? "",
        ico: json["ico"] ?? "",
      );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["parent_id"] = parentId;
    map["name"] = name;
    map["ico"] = ico;
    return map;
  }
}

class CatModel {
  CatModel({
    required this.id,
    required this.parentId,
    required this.childCount,
    required this.name,
    required this.ico,
    this.selectedItem = false,
    this.childAllSelected = true,
    this.adding = false,
  });

  int id;
  int parentId;
  int childCount;
  String name;
  String ico;
  bool selectedItem;
  bool childAllSelected;
  List<CategoryModel> chooseItem = [];
  bool adding;
}
