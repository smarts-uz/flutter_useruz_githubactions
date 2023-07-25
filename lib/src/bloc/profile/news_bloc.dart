// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/profile/news_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../model/api/news_detail_model.dart';
import '../../widget/dialog/center_dialog.dart';

class NewsBloc {
  Repository repository = Repository();

  final _fetch = PublishSubject<NewsModel>();
  final _fetchNew = PublishSubject<NewsDetailModel>();

  Stream<NewsModel> get allNews => _fetch.stream;

  Stream<NewsDetailModel> get newsDetail => _fetchNew.stream;

  getAllNews(BuildContext context) async {
    HttpResult response = await repository.getNews();

    if (response.isSuccess) {
      NewsModel data = NewsModel.fromJson(
        response.result,
      );

      _fetch.sink.add(data);
    }else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllNews(context);
        });
      }
    }
  }

  getNewDetail(int id,BuildContext context) async {
    HttpResult response = await repository.getNewsDt(id);
    if (response.isSuccess) {
      NewsDetailModel data = NewsDetailModel.fromJson(
        response.result,
      );
      _fetchNew.sink.add(data);
    }else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getNewDetail(id,context);
        });
      }
    }
  }
}

final newsBloc = NewsBloc();
