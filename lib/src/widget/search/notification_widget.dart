import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/bloc/notification/notification_bloc.dart';
import 'package:youdu/src/constants/constants.dart';

class NotificationWidget extends StatelessWidget {
  final Function() onTap;

  const NotificationWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: notificationBloc.getNotificationUnread,
      builder: (context, snapshot) {
        bool unread = false;
        if (snapshot.hasData) {
          if (snapshot.data! > 0) {
            unread = true;
          }
        }
        return GestureDetector(
          onTap: () {
            onTap();
          },
          child: Center(
            child: SizedBox(
              height: 28,
              width: 28,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: unread
                        ? Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.yellow16,
                            ),
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SvgPicture.asset(AppAssets.notification),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
