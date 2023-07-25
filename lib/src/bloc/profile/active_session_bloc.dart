// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api/profile/active_session_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class ActiveSessionBloc {
  Repository repository = Repository();

  final _fetchActiveSession = PublishSubject<ActiveSessionModel>();

  Stream<ActiveSessionModel> get getActiveSession => _fetchActiveSession.stream;

  allActiveSession(BuildContext context) async {
    HttpResult response = await repository.activeSession();

    if (response.isSuccess) {
      ActiveSessionModel data = ActiveSessionModel.fromJson(
        response.result,
      );
      _fetchActiveSession.sink.add(data);
    }else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          allActiveSession(context);
        });
      }
    }
  }
}

final activeSessionBloc = ActiveSessionBloc();
