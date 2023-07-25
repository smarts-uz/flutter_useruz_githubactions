// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class AddLinkScreen extends StatefulWidget {
  final String link;
  final Function() onScale;

  const AddLinkScreen({
    super.key,
    required this.link,
    required this.onScale,
  });

  @override
  State<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  Repository repository = Repository();
  final TextEditingController _controller = TextEditingController();
  bool loading = false;
  bool loading1 = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.link;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        title: Text(
          translate("profile.about_me_video"),
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: AppTypography.pSmall3Dark33,
                  cursorColor: AppColors.greyAD,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark33),
                    ),
                    suffix: _controller.text == ""
                        ? null
                        : GestureDetector(
                            onTap: () {
                              _controller.clear();
                              setState(() {});
                            },
                            child: const Icon(Icons.close),
                          ),
                    labelText: translate("profile.youtube_link"),
                    labelStyle: AppTypography.pSmall3,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              widget.link == ""
                  ? Container()
                  : Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            loading1 = true;
                            setState(() {});
                            HttpResult response =
                                await Repository().deleteVideo();
                            if (response.isSuccess) {
                              profileBloc.getProfile(-1, context);
                              Navigator.pop(context);
                            } else if (response.status == -1) {
                              CenterDialog.errorDialog(
                                context,
                                Utils.serverErrorText(response),
                                response.result.toString(),
                              );
                            } else {
                              CenterDialog.errorDialog(
                                context,
                                Utils.serverErrorText(response),
                                response.result.toString(),
                              );
                            }
                            loading1 = false;
                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              translate("profile.delete"),
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamilyProduct,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.red5B,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    )
            ],
          ),
          !loading1
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.dark00.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 56,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.dark00,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              translate("loading"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("profile.save"),
        loading: loading,
        color: _controller.text == widget.link
            ? AppColors.greyD6
            : _controller.text == ""
                ? AppColors.greyD6
                : AppColors.yellow16,
        onTap: _controller.text == widget.link
            ? () {}
            : () async {
                loading = true;
                setState(() {});
                HttpResult response =
                    await repository.addLink(_controller.text);
                loading = false;
                setState(() {});
                if (response.isSuccess && response.result["success"] == true) {
                  profileBloc.getProfile(-1, context);
                  widget.onScale();
                } else if (response.status == -1) {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                } else {
                  CenterDialog.errorDialog(
                    context,
                    Utils.serverErrorText(response),
                    response.result.toString(),
                  );
                }
              },
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }
}
