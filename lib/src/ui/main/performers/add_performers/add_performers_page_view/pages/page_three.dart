// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

import '../../../../../../widget/app/custom_network_image.dart';
import '../../../../more/screens/settings/screens/image_crope.dart';

class PageThree extends StatefulWidget {
  final Function() onTap;

  const PageThree({super.key, required this.onTap});

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  Repository repository = Repository();
  bool wait = false;
  XFile? _imageFile;
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  String name = "";
  String image = "";
  bool error = false;

  @override
  void initState() {
    getName();
    super.initState();
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name") ?? "";
    image = prefs.getString("image") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          image != "" && _imageFile == null
              ? GestureDetector(
                  onTap: () async {
                    getXFile();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: CustomNetworkImage(
                        image: image,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    getXFile();
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: error ? Colors.red : Colors.blue,
                          ),
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(
                                      _imageFile!.path,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(),
                        ),
                        _imageFile != null
                            ? Container()
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(0, 0, 0, 0.6),
                                      Color.fromRGBO(0, 0, 0, 0.6),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 32,
                                    color: AppColors.white,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            height: 24,
          ),
          Text(
            name == "" ? translate("performers.unknown") : name,
            style: AppTypography.h2SmallDark33Normal,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            translate("performers.three.title"),
            textAlign: TextAlign.center,
            style: AppTypography.pTiny215ProDark33,
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("profile.next"),
        loading: wait,
        onTap: () async {
          if (_imageFile != null) {
            if (mounted) {
              setState(() {
                wait = true;
              });
            }
            HttpResult response = await repository.changeImage(
                _imageFile!, "become-performer-avatar");

            if (mounted) {
              setState(() {
                wait = false;
              });
            }
            if (response.isSuccess) {
              if (response.result["success"]) {
                widget.onTap();
                if (mounted) {
                  setState(() {});
                }
              } else {
                _imageFile = null;
              }
            } else if (response.status == -1) {
              CenterDialog.networkErrorDialog(context);
            } else {
              CenterDialog.errorDialog(
                context,
                Utils.serverErrorText(response.result),
                response.result.toString(),
              );
            }
            if (mounted) {
              setState(() {});
            }
          } else {
            widget.onTap();
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

  getXFile() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          color: AppColors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  PickedFile? pickedFile = await _picker.getImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    _imageFile = XFile(pickedFile.path);
                    setData();
                  }
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.white,
                  child: const Center(
                    child: Text(
                      "Gallery",
                      style: AppTypography.pSmallMedium,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: AppColors.dark00.withOpacity(0.6),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  PickedFile? pickedFile = await _picker.getImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    _imageFile = XFile(pickedFile.path);
                    setData();
                  }
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.white,
                  child: const Center(
                    child: Text(
                      "Camera",
                      style: AppTypography.pSmallMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        );
      },
    );
  }

  setData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCrop(
          image: _imageFile!.path,
          onTap: (String img) async {
            _imageFile = XFile(img);
            setState(() {});
          },
        ),
      ),
    );
  }
}
