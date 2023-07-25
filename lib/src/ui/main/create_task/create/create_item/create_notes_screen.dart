// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import '../../../../../widget/app/app_custom_button.dart';
import '../../../more/screens/settings/screens/image_crope.dart';

class CreateNotesScreen extends StatefulWidget {
  final int taskId;
  final TaskModel? taskModel;
  final Function(String _route) nextPage;

  const CreateNotesScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateNotesScreen> createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen>
    with AutomaticKeepAliveClientMixin<CreateNotesScreen> {
  @override
  bool get wantKeepAlive => true;
  bool loading = false, isNext = false;
  bool _value = true;
  final TextEditingController _controller = TextEditingController();
  final List<String> _images = [];
  List<String> photos = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    if (widget.taskModel != null) {
      _controller.text = widget.taskModel!.description;
      isNext = true;
      photos = widget.taskModel!.photos;
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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(bottom: 0),
          controller: controller,
          shrinkWrap: true,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                translate("create_task.note_title"),
                style: AppTypography.h2SmallSemiBold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                translate("create_task.note_info"),
                style: AppTypography.pSmall3H,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      // keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.newline,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 2,
              color: AppColors.greyD6,
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate("create_task.note_doc"),
                          style: AppTypography.pSmallDark33,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          translate("create_task.note_doc_title"),
                          style: AppTypography.pTiny215GreyAD,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: _value,
                    activeColor: AppColors.yellow16,
                    onChanged: (newValue) => setState(() => _value = newValue),
                  ),
                ],
              ),
            ),
            Container(
              height: 16,
              margin: const EdgeInsets.symmetric(vertical: 16),
              color: const Color(0x0ffbfbfb),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                ),
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setData(image.path);
                      }
                    },
                    child: Container(
                      height: 104,
                      width: 104,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppAssets.createFileAdd),
                          const SizedBox(height: 8),
                          Text(
                            translate("create_task.wait"),
                            style: AppTypography.pTinyDark00.copyWith(
                              height: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ..._images.map(
                    (e) => Container(
                      height: 104,
                      width: 104,
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(e),
                              height: 104,
                              width: 104,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 3,
                            child: GestureDetector(
                              child: SvgPicture.asset(
                                AppAssets.createRemoveImage,
                              ),
                              onTap: () {
                                _images.removeAt(_images.indexOf(e));
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ...photos.map(
                    (e) => Container(
                      height: 104,
                      width: 104,
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              e,
                              height: 104,
                              width: 104,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 3,
                            child: GestureDetector(
                              child: SvgPicture.asset(
                                AppAssets.createRemoveImage,
                              ),
                              onTap: () async {
                                HttpResult response =
                                    await Repository().deleteImage(
                                  widget.taskModel!.id,
                                  e.replaceAll(
                                      "https://user.uz/storage/uploads/", ""),
                                );
                                if (response.isSuccess) {
                                  photos.removeAt(photos.indexOf(e));
                                  setState(() {});
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AppCustomButton(
        loading: loading,
        color: isNext ? AppColors.yellow16 : AppColors.greyD6,
        margin: EdgeInsets.only(
          bottom: Platform.isIOS ? 32 : 24,
          left: 32,
        ),
        onTap: () async {
          if (isNext) {
            setState(() {
              loading = true;
            });
            HttpResult response = await createBloc.createNotes(
              _controller.text,
              _value ? "1" : "0",
              widget.taskId,
              _images,
              widget.taskModel,
            );
            if (response.isSuccess) {
              CreateRouteModel data =
                  CreateRouteModel.fromJson(response.result);
              if (data.success) {
                widget.nextPage(
                  data.data.route,
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
    );
  }

  setData(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCrop(
          image: path,
          onTap: (String img) async {
            _images.add(img);
            setState(() {});
          },
        ),
      ),
    );
  }
}
