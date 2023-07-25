// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/balance/balance_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class BalanceBloc {
  Repository repository = Repository();

  final _balance = PublishSubject<BalanceModel>();

  Stream<BalanceModel> get allBalance => _balance.stream;
  BalanceModel allData = BalanceModel.fromJson({});

  getBalance(int type, int month, int page, DateTime startTime,
      DateTime endTime, BuildContext context) async {
    ///get balance api
    HttpResult response =
        await repository.getBalance(type, page, startTime, endTime);

    if (response.isSuccess) {
      BalanceModel data = BalanceModel.fromJson(
        response.result,
      );

      ///pagination
      if (data.data.transaction.meta.currentPage == 1) {
        allData.data.transaction.data.clear();
        allData.data.transaction = data.data.transaction;

        allData.data.balance = data.data.balance;
      } else {
        allData.data.transaction.data.addAll(data.data.transaction.data);
      }

      ///data adding with streaming
      _balance.sink.add(allData);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getBalance(type, month, page, startTime, endTime, context);
        });
      }
    }
  }
}

final balanceBloc = BalanceBloc();
