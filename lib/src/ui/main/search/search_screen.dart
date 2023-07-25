// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/notification/notification_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/database/favorite_storage.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/auth/entrance_screen/entrance_screen.dart';
import 'package:youdu/src/ui/main/search/favorite/favorite_screen.dart';
import 'package:youdu/src/ui/main/search/filter/filter_screen.dart';
import 'package:youdu/src/ui/main/search/item/search_list_screen.dart';
import 'package:youdu/src/ui/main/search/item/search_map_screen.dart';
import 'package:youdu/src/ui/main/search/notification/notification_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';
import 'package:youdu/src/widget/app/search_widget.dart';
import 'package:youdu/src/widget/search/favorite_widget.dart';

import '../../../model/api_model/tasks/favorite_tasks_model.dart';
import '../../../model/api_model/tasks/task_filter_model.dart';
import '../../../widget/search/chat_widget.dart';
import '../../../widget/search/notification_widget.dart';
import 'chat/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String oldText = "", token = "";
  TaskFilterModel filterData = TaskFilterModel(
    response: false,
    distance: 150,
    longitude: 69,
    budget: 0,
    category: [],
    work: false,
    remote: false,
    latitude: 41,
    address: '',
  );
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _getCategory();
    notificationBloc.allNotificationUnreadCount(context);
    notificationBloc.countChat();
    _getToken();
    _controller.addListener(() {
      if (oldText != _controller.text) {
        oldText = _controller.text;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLanguage();
    });
    super.initState();
  }

  Future<void> saveAllFavoriteLocally() async {
    HttpResult response = await Repository().getAllFavoriteTask(1);
    if (response.isSuccess) {
      FavoriteTasksModel data = FavoriteTasksModel.fromJson(
        response.result,
      );
      List<TaskModelResult> favoriteList = data.data;
      int numPages = data.lastPage;
      for (int i = 2; i <= numPages; i++) {
        HttpResult response = await Repository().getAllFavoriteTask(i);
        if (response.isSuccess) {
          FavoriteTasksModel data = FavoriteTasksModel.fromJson(
            response.result,
          );
          favoriteList.addAll(data.data);
        }
      }
      for (int i = 0; i < favoriteList.length; i++) {
        await FavoriteStorage.instance.saveFavorite(favoriteList[i].id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: notificationBloc.getNotificationUnread,
        builder: (context, snapshot) {
          return CupertinoScaffold(
            body: Builder(
              builder: (context) {
                return CupertinoPageScaffold(
                  backgroundColor: Colors.white,
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: AppColors.white,
                      appBar: AppBar(
                        backgroundColor: AppColors.white,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        centerTitle: false,
                        title: AppBarTitle(
                          text: translate("search.title"),
                        ),
                        actions: [
                          NotificationWidget(
                            onTap: () {
                              if (token == "") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const EntranceScreen();
                                    },
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return NotificationScreen(
                                          count: snapshot.data == null
                                              ? 0
                                              : snapshot.data!);
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          FavoriteWidget(
                            onTap: () {
                              if (token == "") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const EntranceScreen();
                                    },
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const FavoriteScreen();
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          ChatWidget(
                            onTap: () {
                              if (token == "") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const EntranceScreen();
                                    },
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ChatScreen();
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      body: Column(
                        children: [
                          SearchWidget(
                            text: translate("search.search"),
                            controller: _controller,
                          ),
                          TabBar(
                            labelColor: AppColors.yellow00,
                            unselectedLabelColor: AppColors.greyBF,
                            indicatorColor: AppColors.yellow00,
                            tabs: [
                              Tab(
                                text: translate("search.list"),
                              ),
                              Tab(
                                text: translate("search.map"),
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SearchListScreen(
                                  filterData: filterData,
                                  dragFunction: _dragFunction,
                                ),
                                SearchMapScreen(
                                  filterData: filterData,
                                  selected: (TaskFilterModel _data) {
                                    filterData = _data;
                                    RxBus.post(_data,
                                        tag: "SEARCH_TASK_FILTER");
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: AppColors.yellow16,
                        child: Center(
                          child: SvgPicture.asset(AppAssets.filter),
                        ),
                        onPressed: () {
                          CupertinoScaffold.showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return FilterScreen(
                                data: filterData,
                                selected: (TaskFilterModel _data) {
                                  filterData = _data;
                                  RxBus.post(_data, tag: "SEARCH_TASK_FILTER");
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  void _dragFunction(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx < 0) {
      if (token == "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const EntranceScreen();
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ChatScreen();
            },
          ),
        );
      }
    } else {
      return;
    }
  }

  Future<void> _setLanguage() async {
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(
        Locale(LanguagePerformers.getLanguage()),
      );
    });
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("accessToken") ?? "";
    if (token.isNotEmpty) {
      saveAllFavoriteLocally();
    }
    setState(() {});
  }

  Future<void> _getCategory() async {
    HttpResult response = await Repository().allCategory();
    if (response.isSuccess) {
      List<CategoryModel> data =
          AllCategoryModel.fromJson(response.result).data;
      filterData.category = data;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
