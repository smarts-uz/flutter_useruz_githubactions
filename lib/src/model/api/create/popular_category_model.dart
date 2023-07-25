import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';

List<PopularCategoryModel> popularCategoryModelFromJson(List list) =>
    List<PopularCategoryModel>.from(
        list.map((e) => PopularCategoryModel.fromJson(e)));

class PopularCategoryModel {
  PopularCategoryModel({
    required this.categoryId,
    required this.total,
    required this.category,
  });

  int categoryId;
  dynamic total;
  CategoryModel category;

  factory PopularCategoryModel.fromJson(Map<String, dynamic> json) =>
      PopularCategoryModel(
        categoryId: json["category_id"] ?? 0,
        total: json["total"] ?? 0,
        category: json["category"] == null
            ? CategoryModel.fromJson({})
            : CategoryModel.fromJson(json["category"]),
      );
}
