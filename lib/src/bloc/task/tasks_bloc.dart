// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/api_model/tasks/same_task_model.dart';
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/model/total_model.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class TasksBloc {
  final Repository repository = Repository();
  final _tasks = PublishSubject<TasksModel>();
  final _taskInfo = PublishSubject<TaskModel>();
  final _taskCount = PublishSubject<TaskCount>();

  Stream<TasksModel> get allTasks => _tasks.stream;

  Stream<TaskCount> get getTaskCount => _taskCount.stream;

  Stream<TaskModel> get infoTasks => _taskInfo.stream;

  TasksModel _allTaskModel = TasksModel.fromJson({});

  Future<bool> getAllTasks(int page, String search, TaskFilterModel filter,
      BuildContext context) async {
    String category = "[";
    for (int i = 0; i < filter.category.length; i++) {
      if (filter.category[i].selectedItem) {
        category += "${filter.category[i].id},";
      } else {
        for (int j = 0; j < filter.category[i].chooseItem.length; j++) {
          category += "${filter.category[i].chooseItem[j].id},";
        }
      }
    }
    if (category != "[") {
      category = category.substring(0, category.length - 1);
      category += "]";
    } else {
      category = "";
    }
    HttpResult response = await repository.getTask(
      lat: filter.latitude.toString(),
      long: filter.longitude.toString(),
      difference: (filter.distance.toInt()).toString(),
      withoutResponse: filter.response ? "1" : "",
      isRemote: filter.remote ? "1" : "",
      search: search,
      budget: filter.budget == 0 ? "" : filter.budget.toString(),
      category: '',
      categoryChild: filter.category.isEmpty ? "" : category,
      page: page,
    );

    if (response.isSuccess) {
      if (page == 1) {
        _allTaskModel = TasksModel.fromJson({});
      }
      TasksModel data = TasksModel.fromJson(
        response.result,
      );
      _allTaskModel.data.addAll(data.data);
      _allTaskModel.lastPage = data.lastPage;
      _tasks.sink.add(_allTaskModel);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllTasks(page, search, filter, context);
        });
      }
      return true;
    }
  }

  getFilterCount(TaskFilterModel filter, BuildContext context) async {
    _taskCount.sink.add(
      TaskCount(
        total: 0,
        load: true,
      ),
    );
    String category = "[";
    for (int i = 0; i < filter.category.length; i++) {
      if (filter.category[i].selectedItem) {
        category += "${filter.category[i].id},";
      } else {
        for (int j = 0; j < filter.category[i].chooseItem.length; j++) {
          category += "${filter.category[i].chooseItem[j].id},";
        }
      }
    }
    if (category != "[") {
      category = category.substring(0, category.length - 1);
      category += "]";
    } else {
      category = "";
    }
    HttpResult response = await repository.getTask(
      lat: filter.latitude.toString(),
      long: filter.longitude.toString(),
      difference: (filter.distance.toInt()).toString(),
      withoutResponse: filter.response ? "1" : "",
      isRemote: filter.remote ? "1" : "",
      search: "",
      budget: filter.budget == 0 ? "" : filter.budget.toString(),
      category: '',
      categoryChild: filter.category.isEmpty ? "" : category,
      page: 1,
    );

    if (response.isSuccess) {
      TasksModel data = TasksModel.fromJson(
        response.result,
      );
      _taskCount.sink.add(
        TaskCount(
          total: data.total,
        ),
      );
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getFilterCount(filter, context);
        });
      }
    }
  }

  getInfoTask(int id, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("id") ?? 0;
    HttpResult response = await repository.getInfoTask(id);
    HttpResult response1 = await repository.getSameTasks(id);
    if (response.isSuccess) {
      ProductModel data = productModelFromJson(
        json.encode(response.result),
      );
      SameTaskDataModel sameData = SameTaskDataModel.fromJson(
        response1.result,
      );
      data.data.isMine = data.data.user.id == userId;
      if (response1.isSuccess) {
        data.data.sameData = sameData.data;
        _taskInfo.sink.add(
          data.data,
        );
      }
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getInfoTask(id, context);
        });
      }
    }
  }
}

final taskBloc = TasksBloc();
