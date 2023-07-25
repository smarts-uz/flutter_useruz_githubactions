// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/guest/performers/all_performers_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../../model/api_model/guest/performers/performers_filter_model.dart';
import '../../../widget/dialog/center_dialog.dart';

class PerformersBloc {
  final Repository _repository = Repository();
  final _fetchPerformers = PublishSubject<AllPerformersModel>();

  Stream<AllPerformersModel> get getAllPerformers => _fetchPerformers.stream;

  AllPerformersModel performersData = AllPerformersModel.fromJson({});

  Future<bool> allPerformers(
      bool online, int page, BuildContext context) async {
    HttpResult response = await _repository.allPerformers(online, page);
    if (response.isSuccess) {
      AllPerformersModel data = allPerformersModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        performersData = AllPerformersModel.fromJson({});
      }
      performersData.data.addAll(data.data);
      performersData.links = data.links;
      performersData.meta = data.meta;

      _fetchPerformers.sink.add(performersData);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          performersBloc.allPerformers(online, page, context);
        });
      }
      return true;
    }
  }
}

class FilterPerformersBloc {
  final Repository _repository = Repository();
  final _fetchPerformers = PublishSubject<AllPerformersModel>();

  Stream<AllPerformersModel> get getAllPerformers => _fetchPerformers.stream;

  AllPerformersModel performersData = AllPerformersModel.fromJson({});

  Future<bool> allPerformers(String search, PerformersFilterModel filter,
      bool online, int page, BuildContext context) async {
    String category = "[";
    for (int i = 0; i < filter.categories.length; i++) {
      if (filter.categories[i].isNotEmpty) {
        for (int j = 0; j < filter.categories[i].length; j++) {
          category += "${filter.categories[i][j]},";
        }
      }
    }
    if (category != "[") {
      category = category.substring(0, category.length - 1);
      category += "]";
    } else {
      category = "";
    }

    HttpResult response =
        await _repository.getPerformers(search, category, filter, online, page);
    if (response.isSuccess) {
      AllPerformersModel data = allPerformersModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        performersData = AllPerformersModel.fromJson({});
      }
      performersData.data.addAll(data.data);
      performersData.links = data.links;
      performersData.meta = data.meta;

      _fetchPerformers.sink.add(performersData);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          filterPerformersBloc.allPerformers(
              search, filter, online, page, context);
        });
      }
      return true;
    }
  }
}

final filterPerformersBloc = FilterPerformersBloc();

final performersBloc = PerformersBloc();
