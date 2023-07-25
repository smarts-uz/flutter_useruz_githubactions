// ignore_for_file: prefer_interpolation_to_compose_strings, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/chat/chat_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/chat/chat_history_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/search/chat/chat_item_screen.dart';
import 'package:youdu/src/ui/main/search/chat/chat_search_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool load = false;

  @override
  void initState() {
    chatBloc.allChatHistory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: SvgPicture.asset(AppAssets.back),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ChatSearchScreen();
                  },
                ),
              );
            },
            child: SvgPicture.asset(
              AppAssets.search,
              height: 24,
              width: 24,
              color: AppColors.yellow00,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    translate("search.message"),
                    style: AppTypography.h1Bold,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<CharHistoryResult>>(
                    stream: chatBloc.getChatHistory,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CharHistoryResult> data = snapshot.data!;
                        return data.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                  'assets/anim/empty.json',
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: restart,
                                color: AppColors.yellow00,
                                backgroundColor: AppColors.white,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    right: 16,
                                    left: 16,
                                  ),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                CenterDialog.selectDialog(
                                                  context,
                                                  translate("close_task_title"),
                                                  (value) async {
                                                    load = true;
                                                    setState(() {});
                                                    HttpResult response =
                                                        await Repository()
                                                            .chatDelete(
                                                                data[index]
                                                                    .user
                                                                    .id);
                                                    chatBloc.allChatHistory(
                                                        context);
                                                    load = false;
                                                    setState(() {});
                                                    if (response.isSuccess) {
                                                      Fluttertoast.showToast(
                                                        msg: translate(
                                                            "chat_deleted"),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    } else {
                                                      if (response.status ==
                                                          -1) {
                                                        CenterDialog
                                                            .networkErrorDialog(
                                                                context);
                                                      } else {
                                                        CenterDialog
                                                            .errorDialog(
                                                          context,
                                                          Utils.serverErrorText(
                                                              response),
                                                          response.result
                                                              .toString(),
                                                        );
                                                      }
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 24,
                                                        horizontal: 16),
                                                color: AppColors.white,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .restore_from_trash_outlined,
                                                      color: AppColors.red5B,
                                                      size: 28,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      translate("delete_chat"),
                                                      style:
                                                          AppTypography.pHRed5B,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onTap: () {
                                        chatBloc.allChatHistory(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ChatItemScreen(
                                                id: data[index].user.id,
                                                avatar: data[index].user.avatar,
                                                name: data[index].user.name,
                                                time: data[index].user.lastSeen,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 52,
                                                  width: 52,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          child:
                                                              CustomNetworkImage(
                                                            image: data[index]
                                                                .user
                                                                .avatar,
                                                            height: 48,
                                                            width: 48,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(48),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(top: 4),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: data[index]
                                                                    .unseenCounter <=
                                                                0
                                                            ? Container()
                                                            : Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: AppColors
                                                                      .yellow16,
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    data[index]
                                                                        .unseenCounter
                                                                        .toString(),
                                                                    style: AppTypography
                                                                        .tinyText,
                                                                  ),
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              data[index]
                                                                  .user
                                                                  .name,
                                                              style: AppTypography
                                                                  .pSmall1Dark00SemiBold,
                                                            ),
                                                          ),
                                                          data[index]
                                                                  .lastMessage
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  Utils.numberFormat(
                                                                        data[index]
                                                                            .lastMessage
                                                                            .first
                                                                            .createdAt
                                                                            .day,
                                                                      ) +
                                                                      "-" +
                                                                      Utils.numberFormat(
                                                                        data[index]
                                                                            .lastMessage
                                                                            .first
                                                                            .createdAt
                                                                            .month,
                                                                      ) +
                                                                      "-" +
                                                                      Utils.numberFormat(
                                                                        data[index]
                                                                            .lastMessage
                                                                            .first
                                                                            .createdAt
                                                                            .year,
                                                                      ),
                                                                  style: AppTypography
                                                                      .tinyText2,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      data[index]
                                                              .lastMessage
                                                              .isNotEmpty
                                                          ? Text(
                                                              data[index]
                                                                  .lastMessage
                                                                  .first
                                                                  .body
                                                                  .toString(),
                                                              style: AppTypography
                                                                  .pTinyGrey84,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 1,
                                              margin: const EdgeInsets.only(
                                                left: 60,
                                                top: 16,
                                              ),
                                              width: double.infinity,
                                              color: AppColors.greyEB,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
            load
                ? Container(
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
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<bool> restart() async {
    bool k = await chatBloc.allChatHistory(context);
    return k;
  }
}
