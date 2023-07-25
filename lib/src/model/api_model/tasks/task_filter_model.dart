import '../guest/categories/category_model.dart';

class TaskFilterModel {
  List<CategoryModel> category;
  final double latitude;
  final double longitude;
  final double distance;
  final int budget;
  final bool remote;
  final bool response;
  final bool work;
  final String address;

  TaskFilterModel({
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.budget,
    required this.distance,
    required this.remote,
    required this.work,
    required this.response,
    required this.address,
  });
}
