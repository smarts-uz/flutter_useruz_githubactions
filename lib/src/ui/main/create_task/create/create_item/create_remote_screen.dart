// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class CreateRemoteScreen extends StatefulWidget {
  final int taskId;
  final TaskModel? taskModel;
  final Function(String route, int address) nextPage;

  const CreateRemoteScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateRemoteScreen> createState() => _CreateRemoteScreenState();
}

class _CreateRemoteScreenState extends State<CreateRemoteScreen>
    with AutomaticKeepAliveClientMixin<CreateRemoteScreen> {
  @override
  bool get wantKeepAlive => true;
  int remoteType = 1;
  bool loading = false;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate("create_task.remote_title"),
            style: AppTypography.h2SmallSemiBold,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                remoteType = 1;
              });
            },
            child: Container(
              height: 60,
              color: Colors.transparent,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      translate("create_task.remote_1"),
                      style: AppTypography.pSmallDark33H11,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 370),
                    curve: Curves.easeInOut,
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: remoteType == 1
                          ? AppColors.yellow00
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: remoteType == 1
                            ? AppColors.yellow00
                            : AppColors.greyD6,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(AppAssets.createCheck),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                remoteType = 0;
              });
            },
            child: Container(
              height: 60,
              color: Colors.transparent,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      translate("create_task.remote_2"),
                      style: AppTypography.pSmallDark33H11,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 370),
                    curve: Curves.easeInOut,
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: remoteType == 0
                          ? AppColors.yellow00
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: remoteType == 0
                            ? AppColors.yellow00
                            : AppColors.greyD6,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(AppAssets.createCheck),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const Spacer(),
          AppCustomButton(
            loading: loading,
            margin: EdgeInsets.only(
              bottom: Platform.isIOS ? 32 : 24,
            ),
            onTap: () async {
              setState(() {
                loading = true;
              });
              HttpResult response = await createBloc.createRemote(
                remoteType == 1 ? "remote" : "address",
                widget.taskId,
                widget.taskModel,
              );
              if (response.isSuccess) {
                CreateRouteModel data =
                    CreateRouteModel.fromJson(response.result);
                if (data.success) {
                  widget.nextPage(
                    data.data.route,
                    data.data.address,
                  );
                } else {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                }
              } else if (response.status == -1) {
                CenterDialog.networkErrorDialog(context);
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
              setState(() {
                loading = false;
              });
            },
            title: translate("next"),
          ),
        ],
      ),
    );
  }
}
