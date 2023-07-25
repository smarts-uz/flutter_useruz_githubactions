// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:youdu/src/bloc/notification/notification_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/notification_model.dart';
import 'package:youdu/src/ui/main/more/screens/news/news_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/change_password_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.count});
  final int count;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool visible = false;
  @override
  void initState() {
    notificationBloc.allNotification(context);
    notificationBloc.getCount(context);
    visible = widget.count != 0;
    super.initState();
  }

  @override
  void dispose() {
    notificationBloc.getCount(context);
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.04),
                offset: const Offset(0, 2),
                blurRadius: 25,
              )
            ],
          ),
          child: AppBar(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.88),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.back,
                ),
              ),
            ),
            elevation: 0.0,
            title: Text(
              translate("search.notification"),
              style: AppTypography.pSmall1,
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(kToolbarHeight),
      ),
      body: StreamBuilder<List<NotificationResult>>(
        stream: notificationBloc.getNotification,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NotificationResult> data = snapshot.data!;

            return data.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/anim/empty.json',
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 4,
                            left: 20,
                            right: 16,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (data[index].isRead == 0) {
                                  notificationBloc.click(data[index].id,
                                      data[index].taskId, context);
                                }
                                if (data[index].type == 14) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen(id: -1),
                                    ),
                                  );
                                } else if (data[index].type == 13) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen(),
                                    ),
                                  );
                                } else if (data[index].taskId == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NewsScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductItemScreen(
                                        id: data[index].taskId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/${typeToImage(data[index].type)}",
                                          height: 54,
                                          width: 54,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data[index].title,
                                                      style: AppTypography
                                                          .pSamll1SemiBoldDark00,
                                                    ),
                                                  ),
                                                  data[index].isRead == 0
                                                      ? Container(
                                                          height: 8,
                                                          width: 8,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: AppColors
                                                                .yellow16,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                data[index].taskName,
                                                style:
                                                    AppTypography.pTinyDark00,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    data[index].createdAt,
                                                    style: AppTypography
                                                        .pTinyGreyB3,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 2,
                                        left: 50,
                                      ),
                                      height: 1,
                                      color: AppColors.greyEB,
                                      width: double.infinity,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: YellowButton(
                            text: translate("all_notification"),
                            loading: loading,
                            onTap: () async {
                              setState(() {
                                loading = true;
                              });
                              await notificationBloc
                                  .readAllNotifications(context)
                                  .then((_) {
                                for (var element in data) {
                                  if (element.isRead == 0) {
                                    element.isRead = 1;
                                  }
                                }
                                visible = false;
                                loading = false;
                                setState(() {});
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
          }
          return Container();
        },
      ),
    );
  }

  String typeToImage(int type) {
    switch (type) {
      case 1:
        {
          return "notification_1.png";
        }
      case 2:
        {
          return "notification_2.png";
        }
      case 3:
        {
          return "notification_3.png";
        }
      case 4:
        {
          return "notification_4.png";
        }
      case 5:
        {
          return "notification_5.png";
        }
      default:
        {
          return "notification_6.png";
        }
    }
  }
}
