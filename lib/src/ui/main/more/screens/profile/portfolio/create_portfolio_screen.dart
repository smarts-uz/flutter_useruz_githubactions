// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/portfolio_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/profile/profile_text_field.dart';

class CreatePortfolioScreen extends StatefulWidget {
  const CreatePortfolioScreen({super.key});

  @override
  State<CreatePortfolioScreen> createState() => _CreatePortfolioScreenState();
}

class _CreatePortfolioScreenState extends State<CreatePortfolioScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<XFile> images = <XFile>[];
  bool loading = false;
  Repository repository = Repository();
  final ImagePicker _picker = ImagePicker();
  String? error1, error2;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      error1 = null;
      setState(() {});
    });
    _contentController.addListener(() {
      error2 = null;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          translate("profile.add_album"),
          style: AppTypography.pSmallRegularDark33.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileTextField(
            controller: _titleController,
            text: translate("profile.name"),
            error: error1,
          ),
          ProfileTextField(
            controller: _contentController,
            text: translate("profile.portfolio_desc"),
            maxLength: 5,
            error: error2,
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width,
            color: AppColors.greyFB,
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                ),
                itemCount: images.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () async {
                        final List<XFile> pickedFile =
                            await _picker.pickMultiImage(
                          //source: ImageSource.gallery,
                          maxWidth: 1000,
                          maxHeight: 1000,
                          imageQuality: 100,
                        );
                        images.addAll(pickedFile);
                        setState(() {});
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.grayF8,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.addRing,
                                color: AppColors.dark00,
                              ),
                              Text(
                                translate("profile.download"),
                                style: AppTypography.pTinyDark33,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Container(
                          height: 104,
                          width: 104,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(images[index - 1].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              images.removeAt(index - 1);
                              setState(() {});
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(top: 2, right: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.dark33,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.closeX,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        color:
            _titleController.text == "" ? AppColors.greyD6 : AppColors.yellow16,
        onTap: _titleController.text == ""
            ? () {}
            : () async {
                if (images.isEmpty) {
                  CenterDialog.errorDialog(
                    context,
                    translate("add_album_error"),
                    translate("add_album_error"),
                  );
                } else {
                  if (_titleController.text.isEmpty) {
                    error1 = translate("empty_text");
                  }

                  if (error1 == null && error2 == null) {
                    loading = true;
                    setState(() {});
                    HttpResult response = await repository.createPortfolio(
                      images,
                      _titleController.text,
                      _contentController.text,
                    );
                    loading = false;
                    setState(() {});
                    if (response.isSuccess) {
                      if (response.result["success"]) {
                        portfolioBloc.getPortfolio(-1, context);
                        Navigator.pop(context);
                      } else {
                        CenterDialog.errorDialog(
                          context,
                          Utils.serverErrorText(response),
                          response.result.toString(),
                        );
                      }
                    } else {
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
                  } else {
                    setState(() {});
                  }
                }
              },
        text: translate("profile.save"),
        loading: loading,
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }
}
