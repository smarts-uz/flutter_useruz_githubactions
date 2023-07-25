// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../../widget/dialog/center_dialog.dart';

class CategoryBloc {
  final Repository _repository = Repository();
  final _fetchCategory = PublishSubject<List<CategoryModel>>();
  final _fetchSubCategory = PublishSubject<List<CategoryModel>>();

  Stream<List<CategoryModel>> get getAllCategory => _fetchCategory.stream;

  Stream<List<CategoryModel>> get getSubCategory => _fetchSubCategory.stream;

  allCategory(BuildContext context) async {
    HttpResult response = await _repository.allCategory();
    if (response.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(response.result).data;
      _fetchCategory.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          allCategory(context);
        });
      }
    }
  }

  allSubCategory(int id, BuildContext context) async {
    HttpResult response = await _repository.allSubCategory(id);
    if (response.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(response.result).data;
      _fetchSubCategory.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          allSubCategory(id, context);
        });
      }
    }
  }
}

final categoryBloc = CategoryBloc();
