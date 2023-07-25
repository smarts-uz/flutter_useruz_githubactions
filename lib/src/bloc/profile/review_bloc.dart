// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api_model/profile/review_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class ReviewBloc {
  Repository repository = Repository();

  final _fetch = PublishSubject<ReviewModel>();

  Stream<ReviewModel> get allReview => _fetch.stream;

  getAllReview(
      int perform, int user, String review, BuildContext context) async {
    HttpResult response = await repository.getReviews(perform, user, review);

    if (response.isSuccess) {
      ReviewModel data = ReviewModel.fromJson(
        response.result,
      );
      _fetch.sink.add(data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getAllReview(perform, user, review, context);
        });
      }
    }
  }
}

final reviewBloc = ReviewBloc();
