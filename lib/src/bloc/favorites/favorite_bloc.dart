// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/tasks/favorite_tasks_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class FavoriteTasksBloc {
  final Repository _repository = Repository();
  final _fetchFavoriteTasks = PublishSubject<FavoriteTasksModel>();

  Stream<FavoriteTasksModel> get getAllFavoriteTasks =>
      _fetchFavoriteTasks.stream;

  FavoriteTasksModel favoriteTasksData = FavoriteTasksModel.fromJson({});

  Future<bool> allFavoriteTasks(int page, BuildContext context) async {
    HttpResult response = await _repository.getAllFavoriteTask(page);
    if (response.isSuccess) {
      FavoriteTasksModel data = FavoriteTasksModel.fromJson(response.result);
      if (page == 1) {
        favoriteTasksData = FavoriteTasksModel.fromJson({});
      }
      favoriteTasksData.data.addAll(data.data);
      favoriteTasksData.lastPage = data.lastPage;
      _fetchFavoriteTasks.sink.add(favoriteTasksData);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          favoriteTasksBloc.allFavoriteTasks(page, context);
        });
      }
      return true;
    }
  }
}

final favoriteTasksBloc = FavoriteTasksBloc();
