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
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/profile/profile_text_field.dart';

class UpdatePortfolioScreen extends StatefulWidget {
  final int id;
  final int user;
  final String title;
  final String content;
  final List<String> image;

  const UpdatePortfolioScreen({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.image,
  });

  @override
  State<UpdatePortfolioScreen> createState() => _UpdatePortfolioScreenState();
}

class _UpdatePortfolioScreenState extends State<UpdatePortfolioScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Repository repository = Repository();
  List<XFile> images = <XFile>[];
  List<String> imagePath = [];
  List<String> imageLink = [];
  List<String> deletedImages = [];
  bool loading = false;
  bool _loading1 = false;
  final ImagePicker _picker = ImagePicker();
  String? error1, error2;

  @override
  void initState() {
    super.initState();
    imageLink = widget.image;
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    _titleController.addListener(() {
      error1 = null;
      setState(() {});
    });
    _contentController.addListener(() {
      error2 = null;
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => portfolioBloc.getPortfolio(-1, context).then((_) {
        Navigator.pop(context);
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 1,
          leading: GestureDetector(
            onTap: () {
              portfolioBloc.getPortfolio(-1, context).then((_) {
                Navigator.pop(context);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.transparent,
              child: SvgPicture.asset(AppAssets.back),
            ),
          ),
          title: Text(
            translate("profile.add_album"),
            style: AppTypography.pSmallRegularDark33Bold,
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  _loading1 = true;
                  setState(() {});
                  HttpResult response =
                      await repository.deletePortfolio(widget.id);
                  _loading1 = false;
                  if (mounted) {
                    setState(() {});
                  }
                  if (response.isSuccess) {
                    CenterDialog.messageDialog(
                      context,
                      response.result["data"]["message"].toString(),
                      () {
                        Navigator.pop(context);
                        portfolioBloc.getPortfolio(widget.user, context);
                      },
                    );
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
          ],
        ),
        body: Stack(
          children: [
            Column(
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
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 1000,
                              maxHeight: 1000,
                              imageQuality: 100,
                            );
                            if (pickedFile != null) {
                              images.add(pickedFile);
                            }
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
                        ),
                        ...images.map(
                          (e) => Stack(
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
                                    File(e.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    images.remove(e);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    padding: const EdgeInsets.all(4),
                                    margin:
                                        const EdgeInsets.only(top: 2, right: 2),
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
                          ),
                        ),
                        ...imageLink.map(
                          (e) => Stack(
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
                                  child: CustomNetworkImage(
                                    height: 104,
                                    width: 104,
                                    image: e,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    deletedImages.add(e);
                                    imageLink.remove(e);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    padding: const EdgeInsets.all(4),
                                    margin:
                                        const EdgeInsets.only(top: 2, right: 2),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            !_loading1
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
          color: _titleController.text == ""
              ? AppColors.greyD6
              : widget.title == _titleController.text
                  ? widget.content == _contentController.text
                      ? images.isEmpty && imageLink.isEmpty
                          ? AppColors.greyD6
                          : AppColors.yellow16
                      : AppColors.yellow16
                  : AppColors.yellow16,
          onTap: _titleController.text == ""
              ? () {}
              : widget.title == _titleController.text
                  ? widget.content == _contentController.text
                      ? images.isEmpty && imageLink.isEmpty
                          ? () {}
                          : onButtonPressed
                      : onButtonPressed
                  : onButtonPressed,
          text: translate("profile.save"),
          loading: loading,
          margin: EdgeInsets.only(
            left: 48,
            right: 16,
            bottom: Platform.isIOS ? 24 : 16,
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    if (imageLink.isEmpty && images.isEmpty) {
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

        if (deletedImages.isNotEmpty) {
          for (var element in deletedImages) {
            HttpResult response = await Repository().deletePortImg(
              widget.id,
              element.replaceAll("https://user.uz/storage/portfolio/", ""),
            );

            if (response.isSuccess && response.result["success"] == true) {
              setState(() {});
            } else {
              if (response.status == -1) {
                CenterDialog.networkErrorDialog(context);
                imageLink.addAll(deletedImages);
                setState(() {});
                break;
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
                imageLink.addAll(deletedImages);
                setState(() {});
                break;
              }
            }
          }
        }
        HttpResult response = await repository.updatePortfolio(
          widget.id,
          images,
          _titleController.text,
          _contentController.text,
        );
        loading = false;
        setState(() {});

        if (response.isSuccess) {
          portfolioBloc.getPortfolio(-1, context).then((_) {
            Navigator.pop(context);
          });
        }
      } else {
        setState(() {});
      }
    }
  }
}
