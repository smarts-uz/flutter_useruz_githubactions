import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api/create/popular_category_model.dart';
import 'package:youdu/src/model/api/create/send_address_model.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../model/api_model/tasks/product_model.dart';

class CreateBloc {
  final Repository _repository = Repository();

  final _fetchPopularCategory = PublishSubject<List<PopularCategoryModel>>();
  final _fetchHistoryCategory = PublishSubject<List<CategoryModel>>();

  Stream<List<PopularCategoryModel>> get getPopularCategory =>
      _fetchPopularCategory.stream;

  Stream<List<CategoryModel>> get getHistory => _fetchHistoryCategory.stream;

  allData(String search) async {
    List<CategoryModel> data = await _repository.getCategory(search);
    _fetchHistoryCategory.sink.add(data);
  }

  saveCategory(CategoryModel item) => _repository.saveCategory(item);

  Future<String> getCategoryName(int id) async {
    HttpResult response = await _repository.getCategoryId(id);
    if (response.isSuccess) {
      CategoryModel category = CategoryModel.fromJson(response.result['data']);
      return category.name;
    }
    return '';
  }

  allPopularCategory(String search) async {
    HttpResult response = await _repository.popularCategory(search);
    if (response.isSuccess) {
      List<PopularCategoryModel> data = popularCategoryModelFromJson(
        response.result,
      );
      _fetchPopularCategory.sink.add(data);
    }
  }

  Future<HttpResult> createName(
    String name,
    int categoryId,
    TaskModel? taskModel,
  ) =>
      _repository.createName(
        name,
        categoryId,
        taskModel,
      );

  Future<HttpResult> createCustom(
    List<CreateRouteCustomField> customFields,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _repository.createCustom(
        customFields,
        taskId,
        taskModel,
      );

  Future<HttpResult> createRemote(
    String radio,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _repository.createRemote(
        radio,
        taskId,
        taskModel,
      );

  Future<HttpResult> createAddress(
    SendAddressModel data,
    TaskModel? taskModel,
  ) =>
      _repository.createAddress(
        data,
        taskModel,
      );

  Future<HttpResult> createDate(
    String startDate,
    String endDate,
    int dateType,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _repository.createDate(
        startDate,
        endDate,
        dateType,
        taskId,
        taskModel,
      );

  Future<HttpResult> createBudget(
    int amount,
    int budgetType,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _repository.createBudget(
        amount,
        budgetType,
        taskId,
        taskModel,
      );

  Future<HttpResult> createNotes(
    String description,
    String docs,
    int taskId,
    List<String> images,
    TaskModel? taskModel,
  ) =>
      _repository.createNotes(
        description,
        docs,
        taskId,
        images,
        taskModel,
      );

  Future<HttpResult> createNumber(
    String phoneNumber,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _repository.createNumber(
        phoneNumber,
        taskId,
        taskModel,
      );

  Future<HttpResult> createNumberVerification(
          String phoneNumber, String smsOtp, String taskId,
          {bool update = false}) =>
      _repository.createNumberVerification(
        phoneNumber,
        smsOtp,
        taskId,
        update,
      );
}

final createBloc = CreateBloc();
