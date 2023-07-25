// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/create_task/performers_image.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

import '../../../../../widget/app/app_custom_button.dart';

class CreateNameScreen extends StatefulWidget {
  final int categoryId;
  final TaskModel? taskModel;
  final String name;
  final int performCount;
  final List performers;
  final Function(
    String _route,
    int _taskId,
    int _address,
    List<CreateRouteCustomField> _customFields,
  ) nextPage;

  const CreateNameScreen({
    super.key,
    required this.categoryId,
    required this.nextPage,
    this.taskModel,
    required this.name,
    required this.performCount,
    required this.performers,
  });

  @override
  State<CreateNameScreen> createState() => _CreateNameScreenState();
}

class _CreateNameScreenState extends State<CreateNameScreen>
    with AutomaticKeepAliveClientMixin<CreateNameScreen> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _controller = TextEditingController();
  bool loading = false, isNext = false;

  @override
  void initState() {
    _controller.text = widget.name;
    if (widget.taskModel != null) {
      _controller.text = widget.taskModel!.name;
      isNext = true;
    }
    if (_controller.text.trim().length > 3) {
      setState(() {
        isNext = true;
      });
    }
    _controller.addListener(() {
      if (_controller.text.trim().length > 3) {
        setState(() {
          isNext = true;
        });
      } else {
        setState(() {
          isNext = false;
        });
      }
    });
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate("create_task.name_title"),
                style: AppTypography.h2SmallSemiBold,
              ),
              const SizedBox(height: 16),
              Text(
                translate("create_task.name_label"),
                style: AppTypography.pSmall3H,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      style: AppTypography.pSmall1P,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: () {
                        _controller.text = "";
                      },
                      child: SvgPicture.asset(AppAssets.clearTextField),
                    ),
                  )
                ],
              ),
              Container(
                height: 2,
                color: AppColors.greyD6,
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 20,
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PerformersImage(imgs: widget.performers),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            "${numberFormat.format(widget.performCount)} ${translate("perform_title")}",
                            style: AppTypography.pSmallDark33Bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      translate("perform_text"),
                      style: AppTypography.pSmall3Dark00.copyWith(
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              AppCustomButton(
                loading: loading,
                color: isNext ? AppColors.yellow16 : AppColors.greyD6,
                margin: EdgeInsets.only(bottom: Platform.isIOS ? 32 : 24),
                onTap: () async {
                  if (isNext &&
                      !loading &&
                      _controller.text.trim().isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    HttpResult response = await createBloc.createName(
                      _controller.text,
                      widget.categoryId,
                      widget.taskModel,
                    );
                    if (response.isSuccess) {
                      CreateRouteModel data =
                          CreateRouteModel.fromJson(response.result);
                      if (data.success) {
                        widget.nextPage(
                          data.data.route,
                          data.data.taskId,
                          data.data.address,
                          data.data.customFields,
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
                  }
                },
                title: translate("next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
