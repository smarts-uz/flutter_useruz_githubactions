// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/template_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/profile/profile_text_field.dart';

class UpdateTemplateScreen extends StatefulWidget {
  final int? id;
  final String? title;
  final String? text;

  const UpdateTemplateScreen({
    super.key,
    this.id,
    this.title,
    this.text,
  });

  @override
  State<UpdateTemplateScreen> createState() => _UpdateTemplateScreenState();
}

class _UpdateTemplateScreenState extends State<UpdateTemplateScreen> {
  Repository repository = Repository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  bool loading = false;
  bool _loading1 = false;
  String? error1;
  String? error2;

  @override
  void initState() {
    super.initState();
    if (widget.title != null && widget.text != null) {
      _titleController.text = widget.title!;
      _textController.text = widget.text!;
      setState(() {});
    }
    _titleController.addListener(() {
      setState(() {});
    });
    _textController.addListener(() {
      setState(() {});
    });

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
          translate("profile.template_for_response"),
          style: AppTypography.pSmallRegularDark33Bold,
        ),
        actions: [
          Visibility(
            visible: widget.id != null,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Text(
                          translate("delete_user"),
                          style: AppTypography.h3Small2,
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              _loading1 = true;
                              setState(() {});
                              HttpResult response =
                                  await repository.deleteTemplate(widget.id!);

                              if (response.isSuccess &&
                                  response.result["success"] == true) {
                                CenterDialog.messageDialog(
                                  context,
                                  response.result["message"].toString() ==
                                          "success"
                                      ? translate("profile.template_deleted")
                                      : "",
                                  () {
                                    templateBloc
                                        .getTemplates(context)
                                        .then((_) {
                                      _loading1 = false;
                                      if (mounted) {
                                        setState(() {});
                                      }
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              } else {
                                _loading1 = false;
                                if (mounted) {
                                  setState(() {});
                                }
                                if (response.status == -1) {
                                  CenterDialog.networkErrorDialog(context);
                                } else {
                                  CenterDialog.errorDialog(
                                    context,
                                    Utils.serverErrorText(response),
                                    response.result.toString(),
                                  );
                                }
                              }
                            },
                            child: Container(
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  translate("delete"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: AppTypography.fontFamilyProxima,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                    color: AppColors.red5B,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  translate("cancel"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: AppTypography.fontFamilyProxima,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                    color: AppColors.dark33,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  color: Colors.transparent,
                  child: Text(
                    translate("profile.delete"),
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamilyProduct,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      height: 24 / 15,
                      color: AppColors.red5B,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            ProfileTextField(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              controller: _titleController,
              text: translate("profile.name"),
              maxLength: 1,
              error: error1,
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileTextField(
              controller: _textController,
              text: translate("profile.portfolio_desc"),
              maxLength: 5,
              error: error2,
              type: TextInputType.text,
            ),
            MediaQuery.of(context).viewInsets.bottom != 0
                ? const SizedBox(
                    height: 120,
                  )
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: YellowButton(
        color: _titleController.text.trim().isEmpty
            ? AppColors.greyD6
            : _textController.text.trim().isEmpty
                ? AppColors.greyD6
                : _titleController.text == widget.title
                    ? _textController.text == widget.text
                        ? AppColors.greyD6
                        : AppColors.yellow16
                    : AppColors.yellow16,
        text: translate("profile.save"),
        loading: loading,
        onTap: _titleController.text.trim().isEmpty
            ? () {}
            : _textController.text.trim().isEmpty
                ? () {}
                : _titleController.text == widget.title
                    ? _textController.text == widget.text
                        ? () {}
                        : _onTap
                    : _onTap,
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  String? error(String text, int minLength) {
    if (text.trim() != "" && text.trim().length < minLength) {
      return translate("profile.about_me_error");
    } else {
      return null;
    }
  }

  void _onTap() async {
    setState(() {
      error1 = error(_titleController.text, 1);
      error2 = error(_textController.text, 10);
    });
    if (error1 == null && error2 == null) {
      loading = true;
      setState(() {});

      HttpResult response =
          (widget.id == null && widget.title == null && widget.text == null)
              ? await repository.createTemplate(
                  _titleController.text, _textController.text)
              : await repository.editTemplate(
                  widget.id!, _titleController.text, _textController.text);

      if (response.isSuccess && response.result["success"] == true) {
        templateBloc.getTemplates(context).then((value) {
          loading = false;
          setState(() {});
          Navigator.pop(context);
        });
      } else {
        loading = false;
        setState(() {});
        if (response.status == -1) {
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
      }
    }
  }
}
