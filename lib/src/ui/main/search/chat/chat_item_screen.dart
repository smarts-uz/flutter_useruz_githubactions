// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youdu/src/bloc/chat/chat_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/chat/chat_message_model.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/image_crope.dart';
import 'package:youdu/src/ui/main/my_task/product/item/image_view.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class ChatItemScreen extends StatefulWidget {
  final int id;
  final String name, avatar, time;

  const ChatItemScreen({
    super.key,
    required this.id,
    required this.name,
    required this.avatar,
    required this.time,
  });

  @override
  State<ChatItemScreen> createState() => _ChatItemScreenState();
}

class _ChatItemScreenState extends State<ChatItemScreen> {
  final TextEditingController _controller = TextEditingController();
  bool chat = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  setData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCrop(
          image: _imageFile!.path,
          onTap: (String img) async {
            // setState(() {
            //   wait = true;
            // });
            chatBloc.allChatSendImage(widget.id, File(img), context);

            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    chatBloc.allChatMessage(widget.id);
    _controller.addListener(() {
      if (_controller.text.replaceAll(" ", "").isNotEmpty) {
        if (!chat) {
          setState(() {
            chat = true;
          });
        }
      } else {
        if (chat) {
          setState(() {
            chat = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: const BackWidget(),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  id: widget.id,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: CustomNetworkImage(
                    image: widget.avatar,
                    height: 42,
                    width: 42,
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamilyProduct,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Color(0xFF2B2D33),
                        ),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamilyProduct,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: AppColors.dark33,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessageResult>>(
              stream: chatBloc.getChatMessage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatMessageResult> data = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      bool isMine = data[index].toId == widget.id;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: isMine
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: data[index].attachment.type == ""
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: isMine
                                                ? const Color(0xFF005A91)
                                                : const Color(0xFFEEF4F8),
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                                  const Radius.circular(12),
                                              topLeft:
                                                  const Radius.circular(12),
                                              bottomRight: Radius.circular(
                                                  isMine ? 0 : 12),
                                              bottomLeft: Radius.circular(
                                                  !isMine ? 0 : 12),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          margin: EdgeInsets.only(
                                            left: isMine ? 44 : 0,
                                            right: !isMine ? 44 : 0,
                                          ),
                                          child: Text(
                                            data[index].message,
                                            style: TextStyle(
                                              fontFamily: AppTypography
                                                  .fontFamilyProxima,
                                              fontWeight: FontWeight.w400,
                                              height: 1.4,
                                              fontSize: 15,
                                              color: isMine
                                                  ? Colors.white
                                                  : const Color(
                                                      0xFF000000,
                                                    ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                                  const Radius.circular(12),
                                              topLeft:
                                                  const Radius.circular(12),
                                              bottomRight: Radius.circular(
                                                  isMine ? 0 : 12),
                                              bottomLeft: Radius.circular(
                                                  !isMine ? 0 : 12),
                                            ),
                                          ),
                                          margin: EdgeInsets.only(
                                            left: isMine ? 44 : 0,
                                            right: !isMine ? 44 : 0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                                  const Radius.circular(12),
                                              topLeft:
                                                  const Radius.circular(12),
                                              bottomRight: Radius.circular(
                                                  isMine ? 0 : 12),
                                              bottomLeft: Radius.circular(
                                                  !isMine ? 0 : 12),
                                            ),
                                            child: data[index]
                                                            .attachment
                                                            .type ==
                                                        "file" &&
                                                    data[index].file != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageView(
                                                            file: data[index]
                                                                .file,
                                                            data: [
                                                              data[index]
                                                                  .attachment
                                                                  .path,
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Image.file(
                                                        data[index].file!))
                                                : GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageView(
                                                            file: data[index]
                                                                .file,
                                                            data: [
                                                              data[index]
                                                                  .attachment
                                                                  .path,
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: data[index]
                                                          .attachment
                                                          .path,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                        child: Icon(
                                                          Icons.error,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              data[index].toId == widget.id
                                  ? const Spacer()
                                  : Container(),
                              Text(
                                Utils.fullDateChatFormat(data[index].createdAt),
                                style: const TextStyle(
                                  fontFamily: AppTypography.fontFamilyProxima,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              top: 8,
              right: 16,
              bottom: Platform.isIOS ? 24 : 8,
            ),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 121,
                          color: AppColors.white,
                          margin:
                              EdgeInsets.only(bottom: Platform.isIOS ? 24 : 16),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  PickedFile? pickedFile =
                                      await _picker.getImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    _imageFile = XFile(pickedFile.path);
                                    setData();
                                  }
                                },
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  color: AppColors.white,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Gallery",
                                        style: AppTypography.pSmallMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.dark00.withOpacity(0.6),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  PickedFile? pickedFile =
                                      await _picker.getImage(
                                    source: ImageSource.camera,
                                  );
                                  if (pickedFile != null) {
                                    _imageFile = XFile(pickedFile.path);
                                    setData();
                                  }
                                },
                                child: Container(
                                  height: 60,
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
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 56,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(AppAssets.file),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 180,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        style: AppTypography.pSmallRegular.copyWith(
                          color: const Color(0xFF2B2D33),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: translate("chat.hint"),
                          hintStyle: AppTypography.pSmallRegular.copyWith(
                            color: const Color(0xFF808185),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (chat) {
                      chatBloc.allSendMessage(
                          widget.id, _controller.text, context);
                      _controller.text = "";
                    }
                  },
                  child: Container(
                    height: 56,
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 370),
                        curve: Curves.easeInOut,
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          color: chat ? const Color(0xFF006BAD) : Colors.white,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.sendMessage,
                            color:
                                chat ? Colors.white : const Color(0xFFDEDEDE),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
