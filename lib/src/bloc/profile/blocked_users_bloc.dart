import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/model/api_model/blocked_user_model.dart';

import '../../widget/dialog/center_dialog.dart';

class BlockedUsersBloc {
  Repository repository = Repository();

  final _allBlockedUsers = PublishSubject<AllBlockedusersModel>();
  AllBlockedusersModel blockedUsersData = AllBlockedusersModel.fromJson({});

  Stream<AllBlockedusersModel> get getBlockedUsersList =>
      _allBlockedUsers.stream;

  allBlockedusers(BuildContext context) async {
    HttpResult response = await repository.getBlockedUsersList();

    if (response.isSuccess) {
      AllBlockedusersModel data = AllBlockedusersModel.fromJson(
        response.result,
      );
      blockedUsersData = AllBlockedusersModel.fromJson({});
      blockedUsersData.success = data.success;
      blockedUsersData.data.addAll(data.data);
      _allBlockedUsers.sink.add(blockedUsersData);
      return true;
    } else {
      if (response.status == -1) {
        if (context.mounted) {
          CenterDialog.networkErrorDialog(context, onTap: () {
            allBlockedusers(context);
          });
        }
      }
      return true;
    }
  }
}

final blockedUsersBloc = BlockedUsersBloc();
