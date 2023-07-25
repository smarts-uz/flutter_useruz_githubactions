// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/tasks/otklik_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class TaskViewBloc {
  Repository repository = Repository();

  final taskFetch = PublishSubject();
  final _otklikFetch = PublishSubject<OtklikModel>();

  Stream<OtklikModel> get otklikInfo => _otklikFetch.stream;
  List<Datum> data1 = [];

  getOtklik(int id, String filter, int page, BuildContext context) async {
    HttpResult response = await repository.getOtklikById(id, filter, page);

    if (page == 1) {
      data1 = [];
    }
    if (response.isSuccess) {
      OtklikModel data2 = OtklikModel.fromJson(response.result);
      data1.addAll(data2.data);
      OtklikModel data = OtklikModel(
        data: data1,
        links: data2.links,
        meta: data2.meta,
      );
      _otklikFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getOtklik(id, filter, page, context);
        });
      }
    }
  }
}

final taskViewBloc = TaskViewBloc();
