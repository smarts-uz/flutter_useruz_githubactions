// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';

import 'package:youdu/src/model/api_model/profile/template_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class TemplateBloc {
  final Repository repository = Repository();

  final _tempFetch = PublishSubject<TemplateModel>();

  Stream<TemplateModel> get allTemplate => _tempFetch.stream;

  getTemplates(BuildContext context) async {
    HttpResult response = await repository.getResponseTemplate();
    if (response.isSuccess) {
      TemplateModel data = TemplateModel.fromJson(
        response.result,
      );
      _tempFetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getTemplates(context);
        });
      }
    }
  }
}

final templateBloc = TemplateBloc();
