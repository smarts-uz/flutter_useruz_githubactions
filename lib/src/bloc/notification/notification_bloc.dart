// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api/notification_model.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/utils.dart';

import '../../model/api/chat/chat_history_model.dart';
import '../../ui/main/create_task/create/create_main_screen.dart';
import '../../widget/dialog/center_dialog.dart';

class NotificationBloc {
  final Repository _repository = Repository();
  final _fetchNotification = PublishSubject<List<NotificationResult>>();
  final _fetchNotificationUnread = PublishSubject<int>();
  final _fetchChatUnread = PublishSubject<int>();

  Stream<List<NotificationResult>> get getNotification =>
      _fetchNotification.stream;

  Stream<int> get getNotificationUnread => _fetchNotificationUnread.stream;

  Stream<int> get getChatUnread => _fetchChatUnread.stream;
  NotificationModel data = NotificationModel.fromJson({});

  click(int id, int taskId, BuildContext context) {
    _repository.allNotificationId(id);
    for (int i = 0; i < data.data.length; i++) {
      if (data.data[i].id == id) {
        data.data[i].isRead = 1;
        break;
      }
    }
    getCount(context);
    _fetchNotification.sink.add(data.data);
  }

  allNotification(BuildContext context) async {
    _fetchNotification.sink.add(data.data);
    HttpResult response = await _repository.allNotification();
    if (response.isSuccess) {
      data = NotificationModel.fromJson(response.result);
      _fetchNotification.sink.add(data.data);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          allNotification(context);
        });
      }
    }
  }

  allNotificationUnreadCount(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var provider =
        Provider.of<PerformersFilterProvider>(context, listen: false);
    String token = prefs.getString("accessToken") ?? "";
    if (token != "") {
      HttpResult profileResponse = await _repository.getProfile(-1);
      if (profileResponse.isSuccess) {
        ProfileModel dt = ProfileModel.fromJson(profileResponse.result);
        if (dt.data.activeTask != 1) {
          CenterDialog.createTaskDialog(
            context,
            (k) async {
              if (k) {
                HttpResult responseTask =
                    await _repository.getTaskInfo(dt.data.activeTask);
                if (responseTask.isSuccess) {
                  ProductModel taskData =
                      ProductModel.fromJson(responseTask.result);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMainScreen(
                        categoryId: taskData.data.categoryId,
                        categoryName: taskData.data.categoryName,
                        taskModel: taskData.data,
                        name: taskData.data.categoryName,
                      ),
                    ),
                  );
                }
              } else {
                _repository.changeTaskStatus(LanguagePerformers.getUserId());
                Navigator.pop(context);
              }
            },
          );
        } else if (Platform.isIOS &&
            dt.data.lastVersion != Utils.currentVersion &&
            provider.updateShown == false) {
          provider.updateDialogState(true);
          CenterDialog.updateAppDialog(context, (k) async {
            if (k) {
              if (Platform.isAndroid || Platform.isIOS) {
                Navigator.of(context).pop();
                final appId =
                    Platform.isAndroid ? 'uz.smart.useruz' : 'us.group.useruz';
                final url = Uri.parse(
                  Platform.isAndroid
                      ? "market://details?id=$appId"
                      : "https://apps.apple.com/uz/app/user-uz/id1645713842",
                );

                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              }
            } else {
              Navigator.of(context).pop();
            }
          });
        }
      }
      HttpResult response = await _repository.allNotification();
      if (response.isSuccess) {
        data = NotificationModel.fromJson(response.result);
        getCount(context);
      } else {
        if (response.status == -1) {
          CenterDialog.networkErrorDialog(context, onTap: () {
            allNotificationUnreadCount(context);
          });
        }
      }
    }
  }

  readAllNotifications(BuildContext context) async {
    HttpResult response = await _repository.readAllNotifications();
    if (response.isSuccess) {
      getCount(context);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          readAllNotifications(context);
        });
      }
    }
  }

  getCount(BuildContext context) async {
    HttpResult response = await _repository.getNotificationsCount();
    if (response.isSuccess) {
      NotificationCountModel dataCount =
          NotificationCountModel.fromJson(response.result);
      _fetchNotificationUnread.sink.add(dataCount.count);
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          getCount(context);
        });
      }
    }
  }

  countChat() async {
    int count = 0;
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken") ?? "";
    if (token != "") {
      HttpResult response = await _repository.allChat();
      if (response.isSuccess) {
        ChatHistoryModel data = ChatHistoryModel.fromJson(response.result);
        for (int i = 0; i < data.data.contacts.length; i++) {
          count += data.data.contacts[i].unseenCounter;
        }
      }
    }
    _fetchChatUnread.sink.add(count);
  }

  updateNotification(NotificationResult result, BuildContext context) {
    data.data.add(result);
    getCount(context);
    _fetchNotification.sink.add(data.data);
  }
}

final notificationBloc = NotificationBloc();
