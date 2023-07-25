// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/chat/chat_bloc.dart';
import 'package:youdu/src/bloc/notification/notification_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/security_storage.dart';
import 'package:youdu/src/model/api/chat/chat_message_model.dart';
import 'package:youdu/src/model/api/notification_model.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/ui/main/more/more_screen.dart';
import 'package:youdu/src/ui/main/more/screens/news/news_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/my_task/product/product_item_screen.dart';
import 'package:youdu/src/ui/main/performers/performers_screen.dart';
import 'package:youdu/src/ui/main/search/chat/chat_screen.dart';
import 'package:youdu/src/ui/main/search/notification/notification_screen.dart';
import 'package:youdu/src/ui/main/search/search_screen.dart';
import 'package:intl/intl.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';

import '../../../main.dart';
import '../../utils/language_performers.dart';
import 'create_task/new_search_screen.dart';

import 'more/screens/settings/screens/change_password_screen.dart';
import 'my_task/my_task_screen.dart';

final priceFormat = NumberFormat("#,##0", "ru");
final numberFormat = NumberFormat("#,##0", "ru");

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  String token = "";
  Repository repository = Repository();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().then(
            (appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                //App Update successful
                InAppUpdate.completeFlexibleUpdate();
              }
            },
          );
        }
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    super.initState();
    _rxRegister();
    _getOpen();
    _getToken();

    _notificationFirebase();
    _localeNotification();
    if (Platform.isAndroid) {
      checkForUpdate();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLanguage();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    RxBus.destroy(tag: "CLOSED_USER");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      storeLastExitTime();
    }
  }

  void storeLastExitTime() {
    DateTime now = DateTime.now();
    SecurityStorage.instance.saveLockTime(now);
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: [
        const SearchScreen(),
        const PerformersScreen(),
        token == ""
            ? const EntranceScreen(
                main: true,
              )
            : const NewSearchScreen(),
        token == ""
            ? const EntranceScreen(
                main: true,
              )
            : const MyTaskScreen(),
        token == ""
            ? const EntranceScreen(
                main: true,
              )
            : const MoreScreen(),
      ][_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.white,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 32,
                spreadRadius: 0,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: AppColors.greyA4,
            selectedItemColor: AppColors.yellow00,
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.searchMenu,
                  color: _selectedIndex == 0
                      ? AppColors.yellow00
                      : AppColors.greyA4,
                  height: 24,
                  width: 24,
                ),
                label: translate('search_task'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.performers,
                  color: _selectedIndex == 1
                      ? AppColors.yellow00
                      : AppColors.greyA4,
                  height: 24,
                  width: 24,
                ),
                label: translate('performers.title'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.add,
                  color: Colors.transparent,
                  height: 24,
                  width: 24,
                ),
                label: translate('create'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.myAssignment,
                  color: _selectedIndex == 3
                      ? AppColors.yellow00
                      : AppColors.greyA4,
                  height: 24,
                  width: 24,
                ),
                label: translate('my_task.nav_title'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.profile,
                  color: _selectedIndex == 4
                      ? AppColors.yellow00
                      : AppColors.greyA4,
                  height: 24,
                  width: 24,
                ),
                label: translate('profile.profile'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !showFab,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: AppColors.white),
          child: FloatingActionButton(
            heroTag: 'contact',
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
            backgroundColor: AppColors.white,
            elevation: 7,
            child: Icon(
              Icons.add,
              color:
                  _selectedIndex == 2 ? AppColors.yellow00 : AppColors.greyA4,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _notificationFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString("deviceId") ?? "";
    String token = prefs.getString("accessToken") ?? "";
    if (deviceId == "") {
      deviceId = await FlutterUdid.udid;
      prefs.setString("deviceId", deviceId);
    }
    String deviceName = prefs.getString("deviceName") ?? "";
    if (deviceName == "") {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          deviceName = (await deviceInfoPlugin.androidInfo).model;
        } else if (Platform.isIOS) {
          deviceName = (await deviceInfoPlugin.iosInfo).model ?? "";
        }
        prefs.setString("deviceName", deviceName);
      } catch (_) {}
    }
    if (token != "") {
      FirebaseMessaging.instance.getToken().then((value) {
        Repository().sendFirebaseToken(
          value ?? "",
          deviceId,
          deviceName,
        );
      });
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        openAppScreen(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((event) {
      String type = event.data["type"] ?? "";

      if (type == "notification") {
        NotificationResult notificationResult = NotificationResult.fromJson(
          json.decode(
            event.data["data"],
          ),
        );
        notificationBloc.updateNotification(notificationResult, context);
      } else if (type == "chat") {
        try {
          ChatMessageResult chatMessageResult = ChatMessageResult.fromJson(
            json.decode(
              event.data["data"],
            ),
          );
          chatBloc.allChatHistory(context);
          chatBloc.addData(chatMessageResult);
        } catch (_) {}
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      openAppScreen(event.data);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;

      String payload;

      if (message.data["type"] == "notification") {
        try {
          NotificationResult notificationResult = NotificationResult.fromJson(
            json.decode(
              message.data["data"],
            ),
          );
          if (notificationResult.type == 13) {
            payload = "change_password";
          } else if (notificationResult.type == 14) {
            payload = "profile";
          } else if (notificationResult.taskId != 0) {
            payload = "notification&${notificationResult.taskId}";
          } else {
            payload = "news";
          }
        } catch (_) {
          payload = "news";
        }
      } else {
        payload = "chat";
      }

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        icon: ('@mipmap/ic_stat_icon'),
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
      );
      DarwinNotificationDetails darwinNotificationDetails =
          const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      );
      if (notification != null) {
        NotificationDetails notificationDetails = NotificationDetails(
            iOS: darwinNotificationDetails,
            android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
          payload: payload,
        );
      }
    });
  }

  openAppScreen(Map<String, dynamic> data) {
    String type = data["type"] ?? "";
    _selectedIndex = 0;

    if (type == "notification") {
      try {
        NotificationResult notificationResult = NotificationResult.fromJson(
          json.decode(
            data["data"],
          ),
        );
        if (notificationResult.type == 13) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ChangePasswordScreen();
              },
            ),
          );
        } else if (notificationResult.type == 14) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ProfileScreen(
                  id: -1,
                );
              },
            ),
          );
        } else if (notificationResult.taskId == 0) {
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
                id: notificationResult.taskId,
              ),
            ),
          );
        }
      } catch (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const NotificationScreen(
                count: 0,
              );
            },
          ),
        );
      }
    } else if (type == "chat") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ChatScreen();
          },
        ),
      );
    }
  }

  _rxRegister() {
    RxBus.register(tag: "CLOSED_USER").listen(
      (event) {
        if (mounted) {
          _clearData();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EntranceScreen(),
            ),
          );
        }
      },
    );
  }

  Future<void> _setLanguage() async {
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(
        Locale(
          LanguagePerformers.getLanguage(),
        ),
      );
    });
  }

  Future<void> _getToken() async {
    Utils.checkConnection();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("accessToken") ?? "";
    setState(() {});
  }

  Future<void> _getOpen() async {
    await Repository()
        .changeLanguage(LanguagePerformers.getLanguage(), Utils.currentVersion);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("first_open", true);
  }

  void _localeNotification() {
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {
        String data = payload.split("&").first;
        if (data == "14") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(id: -1),
            ),
          );
        } else if (data == "13") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangePasswordScreen(),
            ),
          );
        } else if (data == "chat") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ChatScreen();
              },
            ),
          );
        } else if (data == "notification") {
          try {
            int taskId = int.parse(payload.split("&").last);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductItemScreen(
                  id: taskId,
                ),
              ),
            );
          } catch (_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const NotificationScreen(
                    count: 0,
                  );
                },
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
