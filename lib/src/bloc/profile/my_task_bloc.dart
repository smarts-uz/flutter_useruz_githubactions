// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/profile/may_task_count_model.dart';
import 'package:youdu/src/model/api_model/profile/my_task_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class MyTaskBloc {
  Repository repository = Repository();
  final _countFetch = PublishSubject<MyTaskCountModel>();
  final _myTaskFetch = PublishSubject<MyTaskModel>();

  Stream<MyTaskCountModel> get allCount => _countFetch.stream;

  Stream<MyTaskModel> get allMyTask => _myTaskFetch.stream;

  Future<bool> getAllCount(int id, BuildContext context) async {
    _countFetch.sink.add(
      MyTaskCountModel(
        success: false,
        data: Data.fromJson({}),
        load: true,
      ),
    );
    HttpResult response = await repository.getMyTaskCount(id);

    if (response.isSuccess) {
      MyTaskCountModel data = MyTaskCountModel.fromJson(
        response.result,
      );
      _countFetch.sink.add(data);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllCount(id, context);
        });
      }
      return true;
    }
  }

  getAllMyTask(
      int status, int performer, int page, BuildContext context) async {
    HttpResult response = await repository.getMyTasks(status, performer, page);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllMyTask(status, performer, page, context);
        });
      }
    }
  }

  getAllTasksByID(int userId, BuildContext context) async {
    HttpResult response = await repository.getAllTasksById(userId);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllTasksByID(userId, context);
        });
      }
    }
  }

  getAllUserTask(int userId, int status, BuildContext context) async {
    HttpResult response = await repository.getUserTasks(userId, status);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllUserTask(userId, status, context);
        });
      }
    }
  }
}

class MyTaskAsPerformerBloc {
  Repository repository = Repository();
  final _countFetch = PublishSubject<MyTaskCountModel>();
  final _myTaskFetch = PublishSubject<MyTaskModel>();

  Stream<MyTaskCountModel> get allCount => _countFetch.stream;

  Stream<MyTaskModel> get allMyTask => _myTaskFetch.stream;

  Future<bool> getAllCount(BuildContext context) async {
    _countFetch.sink.add(
      MyTaskCountModel(
        success: false,
        data: Data.fromJson({}),
        load: true,
      ),
    );
    HttpResult response = await repository.getMyTaskCount(1);

    if (response.isSuccess) {
      MyTaskCountModel data = MyTaskCountModel.fromJson(
        response.result,
      );
      _countFetch.sink.add(data);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllCount(context);
        });
      }
      return true;
    }
  }

  getAllMyTask(
      int status, int page, BuildContext context) async {
    HttpResult response = await repository.getMyTasks(status, 1, page);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllMyTask(status, page, context);
        });
      }
    }
  }

  getAllTasksByID(int userId, BuildContext context) async {
    HttpResult response = await repository.getAllTasksById(userId);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllTasksByID(userId, context);
        });
      }
    }
  }

  getAllUserTask(int userId, int status, BuildContext context) async {
    HttpResult response = await repository.getUserTasks(userId, status);
    if (response.isSuccess) {
      MyTaskModel data = MyTaskModel.fromJson(
        response.result,
      );
      _myTaskFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllUserTask(userId, status, context);
        });
      }
    }
  }
  
 
  
  
}


final myTaskBloc = MyTaskBloc();
final myTaskAsPerformerBloc = MyTaskAsPerformerBloc();
