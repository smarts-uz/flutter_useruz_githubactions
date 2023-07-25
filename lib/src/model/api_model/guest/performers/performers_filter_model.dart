import '../categories/category_model.dart';

class PerformersFilterModel {
  PerformersFilterModel({
    required this.categories,
    required this.childCategories,
    required this.online,
    required this.alphabet,
    required this.review,
    required this.desc,
    required this.asc,
  });

  List<List<int>> categories;
  List<CategoryModel> childCategories;
  bool online;
  bool alphabet;
  bool review;
  bool desc;
  bool asc;
}
