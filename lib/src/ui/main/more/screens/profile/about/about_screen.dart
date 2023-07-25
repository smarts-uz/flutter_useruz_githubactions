// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/profile/profile_text_field.dart';

class AboutScreen extends StatefulWidget {
  final String about;
  final String workExp;

  const AboutScreen({
    super.key,
    required this.about,
    required this.workExp,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Repository repository = Repository();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _workExpController = TextEditingController();
  bool loading = false;
  String? error1;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.about;
    chekWorkExp();
    if (mounted) {
      setState(() {});
    }
  }

  chekWorkExp() {
    if (widget.workExp.trim() != "0") {
      _workExpController.text = widget.workExp;
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
          translate("profile.about_me"),
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                translate("profile.about_me_text"),
                textAlign: TextAlign.start,
                style: AppTypography.pSmall3Grey97,
              ),
            ),
            ProfileTextField(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              controller: _controller,
              text: translate("profile.description"),
              maxLength: 5,
              error: error1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
              child: Text(
                translate("profile.work_exp_text"),
                textAlign: TextAlign.start,
                style: AppTypography.pSmall3Grey97,
              ),
            ),
            ProfileTextField(
              controller: _workExpController,
              text: translate("profile.work_exp"),
              maxLength: 1,
              maxL: 3,
              error: null,
              type: TextInputType.number,
              textFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly,
              ],
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
        text: translate("profile.save"),
        loading: loading,
        onTap: _onTap,
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  String? error(String text) {
    if (text.trim() != "" && text.length < 10) {
      return translate("profile.about_me_error");
    } else {
      return null;
    }
  }

  void _onTap() async {
    setState(() {
      error1 = error(_controller.text);
    });
    if (error1 == null) {
      loading = true;
      setState(() {});
      HttpResult response = await repository.editDescription(_controller.text);
      HttpResult response1 = await repository.editExparience(
          _workExpController.text.trim() == ""
              ? 0
              : int.parse(_workExpController.text));

      if (response.isSuccess &&
          response.result["success"] == true &&
          response1.isSuccess &&
          response1.result["success"] == true) {
        profileBloc.getProfile(-1, context).then((_) {
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
        } else if (response1.status == -1) {
          CenterDialog.errorDialog(
            context,
            Utils.serverErrorText(response1),
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
