// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/profile/portfolio_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class PortfolioBloc {
  final Repository repository = Repository();

  final _portFetch = PublishSubject<PortfolioModel>();

  Stream<PortfolioModel> get allPortfolio => _portFetch.stream;

  getPortfolio(int user,BuildContext context) async {
    HttpResult response = await repository.getPortfolio(user);
    if (response.isSuccess) {
      PortfolioModel data = PortfolioModel.fromJson(
        response.result,
      );
      _portFetch.sink.add(data);
    }else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getPortfolio(user,context);
        });
      }
    }
  }
}

final portfolioBloc = PortfolioBloc();
