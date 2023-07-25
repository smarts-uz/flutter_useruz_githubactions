// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/otklik_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/search/chat/chat_item_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/stars/stars_widget.dart';

class ResponseItemWidget extends StatefulWidget {
  final Datum data;
  final int taskId;
  final bool view;
  final bool isMine;
  final int status;
  final TaskModel taskModel;

  const ResponseItemWidget({
    super.key,
    required this.data,
    required this.taskId,
    required this.isMine,
    required this.view,
    required this.taskModel,
    required this.status,
  });

  @override
  State<ResponseItemWidget> createState() => _ResponseItemWidgetState();
}

class _ResponseItemWidgetState extends State<ResponseItemWidget> {
  Repository repository = Repository();
  final _controller = ActionSliderController();
  int id = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              id: widget.data.user.id,
            ),
          ),
        );
      },
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        //margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: CustomNetworkImage(
                      image: widget.data.user.avatar,
                      height: 54,
                      width: 54,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.user.name,
                      style: AppTypography.pSmallRegularDark33SemiBold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppAssets.clock,
                          height: 14,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.data.user.lastSeen,
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.like,
                          height: 14,
                          width: 14,
                        ),
                        Text(
                          widget.data.user.likes.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        SvgPicture.asset(
                          AppAssets.dislike,
                          height: 14,
                          width: 14,
                        ),
                        Text(
                          widget.data.user.dislikes.toString(),
                          textAlign: TextAlign.start,
                          style: AppTypography.pTinyGrey94.copyWith(
                            color: AppColors.grey95,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        StarsWidget(
                          count: widget.data.user.stars,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  translate("my_task.price"),
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamilyProxima,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.33,
                    color: AppColors.dark33,
                  ),
                ),
                Text(
                  "  ${priceFormat.format(num.parse(widget.data.budget.toString()))} ${translate("sum")}",
                  style: AppTypography.pSmallRegularDark33SemiBold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.data.description,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProxima,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 1.33,
                color: AppColors.dark33,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  translate("my_task.phone"),
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamilyProxima,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.33,
                    color: AppColors.dark33,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var uri = Uri(
                        scheme: 'tel',
                        path: widget.data.user.phoneNumber.length == 12
                            ? "+" + widget.data.user.phoneNumber
                            : widget.data.user.phoneNumber);
                    if ((widget.data.notFree == 1 && widget.view) ||
                        (widget.taskModel.performerId == widget.data.id &&
                            widget.view &&
                            widget.taskModel.status != 4 &&
                            widget.taskModel.status != 6 &&
                            widget.taskModel.status != 5)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      (widget.data.notFree == 1 ||
                                  widget.view ||
                                  widget.data.user.id == id) &&
                              widget.status != 4 &&
                              widget.status != 6 &&
                              widget.status != 5
                          ? widget.data.user.phoneNumber.length == 12
                              ? "+" + widget.data.user.phoneNumber
                              : widget.data.user.phoneNumber
                          : "+998 ** *** ** **",
                      style: AppTypography.pSmallRegularDark33SemiBold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            widget.view &&
                    widget.status != 4 &&
                    widget.status != 6 &&
                    widget.status != 5
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.data.user.id == id
                              ? ChatItemScreen(
                                  id: widget.taskModel.user.id,
                                  name: widget.taskModel.user.name,
                                  avatar: widget.taskModel.user.avatar,
                                  time: "",
                                )
                              : ChatItemScreen(
                                  id: widget.data.user.id,
                                  name: widget.data.user.name,
                                  avatar: widget.data.user.avatar,
                                  time: "",
                                ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: AppColors.greyD6,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          translate("my_task.write"),
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.yellow00,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 16),
            !widget.isMine
                ? Container()
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(56),
                      border: Border.all(
                        color: AppColors.yellow00,
                        width: 2,
                      ),
                    ),
                    child: ActionSlider.standard(
                      height: 56,
                      controller: _controller,
                      action: (e) async {
                        _controller.loading();
                        HttpResult response = await repository.selectPerform(
                          widget.data.id,
                        );

                        if (response.isSuccess) {
                          if (response.result["success"] == true) {
                            _controller.success();
                            setState(() {});
                            CenterDialog.messageDialog(
                              context,
                              translate("my_task.item"),
                              () {},
                            );
                            taskBloc.getInfoTask(widget.taskId, context);
                          } else {
                            _controller.failure();
                            setState(() {});
                            CenterDialog.errorDialog(
                              context,
                              Utils.serverErrorText(response),
                              response.result.toString(),
                            );
                          }
                        } else if (response.status == -1) {
                          _controller.failure();
                          setState(() {});
                          CenterDialog.networkErrorDialog(context);
                        } else {
                          _controller.failure();
                          setState(() {});
                          CenterDialog.errorDialog(
                            context,
                            Utils.serverErrorText(response),
                            response.result.toString(),
                          );
                        }
                      },
                      sliderBehavior: SliderBehavior.stretch,
                      backgroundColor: AppColors.white,
                      boxShadow: const [],
                      successIcon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.checks,
                            color: AppColors.green,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                      icon: Center(
                        child: SvgPicture.asset(
                          AppAssets.arrowRight,
                          color: AppColors.white,
                        ),
                      ),
                      child: Text(
                        translate("my_task.choose"),
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamilyProxima,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          height: 1.3,
                          color: Color(0xFFDFDFDF),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                widget.data.createdAt,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamilyProxima,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  height: 1.38,
                  color: AppColors.grey95,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id") ?? 0;
    setState(() {});
  }
}
