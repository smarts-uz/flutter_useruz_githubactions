// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_field

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/address/create_address_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/create_number_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/create_date_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/create_name_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/create_remote_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/success/success_screen.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/verification_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/widget/app/app_bar_title.dart';

import '../../../../api/repository.dart';
import '../../../../model/api/create/create_route_model.dart';
import 'create_item/create_budget_screen.dart';
import 'create_item/custom/create_custom_screen.dart';
import 'create_item/create_notes_screen.dart';

class CreateMainScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final TaskModel? taskModel;
  final bool myTask;
  final String name;
  final bool edit;

  const CreateMainScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.taskModel,
    this.myTask = false,
    required this.name,
    this.edit = false,
  });

  @override
  State<CreateMainScreen> createState() => _CreateMainScreenState();
}

class _CreateMainScreenState extends State<CreateMainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0, taskId = 0;
  bool _customToAddress = true,
      nameToAddress = true,
      nameToRemote = true,
      remoteToDate = true;
  int userID = 0;

  late TabController _tabController;
  final Duration _duration = const Duration(milliseconds: 270);
  int performCount = 0;
  List performers = [];

  static const int _createNameStep = 0;
  static const int _createCustomStep = 1;
  static const int _createRemoteStep = 2;
  static const int _createAddressStep = 3;
  static const int _createDateStep = 4;
  static const int _createBudgetStep = 5;
  static const int _createNoteStep = 6;
  static const int _createContactStep = 7;

  @override
  void initState() {
    _getData();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    getImage();
    getCount();
    super.initState();
  }

  getCount() async {
    HttpResult response = await Repository().getPerformCount(
        widget.taskModel == null
            ? widget.categoryId
            : widget.taskModel!.categoryId);
    if (response.isSuccess) {
      performCount = response.result["data"];
      setState(() {});
    }
  }

  getImage() async {
    HttpResult response = await Repository().getPerformImage(
        widget.taskModel == null
            ? widget.categoryId
            : widget.taskModel!.categoryId);
    if (response.isSuccess) {
      performers = response.result["data"];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _close();
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(
                widget.taskModel != null
                    ? translate("create_task.break_title")
                    : translate("close_task_title"),
                style: AppTypography.h3Small2,
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.myTask) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                    if ((widget.taskModel == null ||
                            widget.taskModel != null) &&
                        widget.edit == false) {
                      if (widget.taskModel != null) {
                        await Repository()
                            .deleteTask(widget.taskModel!.id, userID);
                      } else {
                        await Repository().deleteTask(taskId, userID);
                      }
                    }
                  },
                  child: Container(
                    height: 44,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        widget.edit
                            ? translate("create_task.break")
                            : translate("delete"),
                        textAlign: TextAlign.center,
                        style: AppTypography.pTiny2BoldRed,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 44,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        translate("next_task"),
                        textAlign: TextAlign.center,
                        style: AppTypography.pTiny2BoldBlue,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              _close();
              if (_currentIndex == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: Text(
                        widget.taskModel != null
                            ? translate("create_task.break_title")
                            : translate("close_task_title"),
                        style: AppTypography.h3Small2,
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            _close();
                            Navigator.pop(context);

                            if (widget.myTask) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                            }
                            if ((widget.taskModel == null ||
                                    widget.taskModel != null) &&
                                widget.edit == false) {
                              if (widget.taskModel != null) {
                                await Repository()
                                    .deleteTask(widget.taskModel!.id, userID);
                              } else {
                                await Repository().deleteTask(taskId, userID);
                              }
                            }
                          },
                          child: Container(
                            height: 44,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                widget.taskModel != null
                                    ? translate("create_task.break")
                                    : translate("delete"),
                                textAlign: TextAlign.center,
                                style: AppTypography.pTiny2BoldRed,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                translate("next_task"),
                                textAlign: TextAlign.center,
                                style: AppTypography.pTiny2BoldBlue,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              } else if (_currentIndex == 2) {
                if (!nameToRemote) {
                  _tabController.animateTo(
                    0,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                } else {
                  _tabController.animateTo(
                    _currentIndex - 1,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                }
              } else if (_currentIndex == 3) {
                if (!_customToAddress) {
                  _tabController.animateTo(
                    1,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                } else if (!nameToAddress) {
                  _tabController.animateTo(
                    0,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                } else {
                  _tabController.animateTo(
                    _currentIndex - 1,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                }
              } else if (_currentIndex == 4) {
                if (!remoteToDate) {
                  _tabController.animateTo(
                    2,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                } else {
                  _tabController.animateTo(
                    _currentIndex - 1,
                    duration: _duration,
                    curve: Curves.easeInOut,
                  );
                }
              } else {
                _tabController.animateTo(
                  _currentIndex - 1,
                  duration: _duration,
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/back.svg",
                  color: AppColors.yellow00,
                ),
              ),
            ),
          ),
          elevation: 0,
          title: AppBarTitle(
            text: widget.categoryName,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: Text(
                        widget.edit
                            ? translate("create_task.break_title")
                            : translate("close_task_title"),
                        style: AppTypography.h3Small2,
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            if (widget.myTask) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                            }
                            if ((widget.taskModel == null ||
                                    widget.taskModel != null) &&
                                widget.edit == false) {
                              if (widget.taskModel != null) {
                                await Repository()
                                    .deleteTask(widget.taskModel!.id, userID);
                              } else {
                                await Repository().deleteTask(taskId, userID);
                              }
                            }
                          },
                          child: Container(
                            height: 44,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                widget.taskModel != null
                                    ? translate("create_task.break")
                                    : translate("delete"),
                                textAlign: TextAlign.center,
                                style: AppTypography.pTiny2BoldRed,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                translate("next_task"),
                                textAlign: TextAlign.center,
                                style: AppTypography.pTiny2BoldBlue,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              child: Center(
                child: Text(
                  translate("cancel"),
                  style: AppTypography.pTiny215Yellow,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: 8,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 270),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 5,
                            width: 32,
                            decoration: BoxDecoration(
                              color: index <= _currentIndex
                                  ? AppColors.yellow00
                                  : AppColors.greyEA,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xFFEFEDE9),
                  height: 1,
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    // allowImplicitScrolling: true,
                    controller: _tabController,
                    // onPageChanged: (_index) {
                    //   setState(() {
                    //     _currentIndex = _index;
                    //   });
                    // },
                    children: [
                      CreateNameScreen(
                        taskModel: widget.taskModel,
                        categoryId: widget.categoryId,
                        nextPage: (
                          String _route,
                          int _taskId,
                          int _address,
                          List<CreateRouteCustomField> _customFields,
                        ) {
                          _close();
                          setState(() {
                            taskId = _taskId;
                          });

                          if (_route == "custom") {
                            _tabController.animateTo(
                              _createCustomStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          } else if (_route == "address") {
                            nameToAddress = false;
                            Timer(_duration, () {
                              RxBus.post(_address, tag: "CREATE_ADDRESS");
                            });
                            _tabController.animateTo(
                              _createAddressStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          } else if (_route == 'remote') {
                            nameToRemote = false;
                            _tabController.animateTo(
                              _createRemoteStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }

                          Timer(_duration, () {
                            RxBus.post(taskId, tag: "CREATE_CUSTOM_TASK_ID");
                            RxBus.post(_customFields, tag: "CREATE_CUSTOM");
                          });
                        },
                        name: widget.name,
                        performCount: performCount,
                        performers: performers,
                      ),
                      CreateCustomScreen(
                        taskModel: widget.taskModel,
                        nextPage: (String _route, int _address) {
                          _close();
                          if (_route == "remote") {
                            _tabController.animateTo(
                              _createRemoteStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          } else if (_route == "address") {
                            _customToAddress = false;
                            setState(() {});
                            _tabController.animateTo(
                              _createAddressStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                            Timer(_duration, () {
                              RxBus.post(_address, tag: "CREATE_ADDRESS");
                            });
                          }
                        },
                      ),
                      CreateRemoteScreen(
                        taskModel: widget.taskModel,
                        taskId: taskId,
                        nextPage: (String _route, int _address) {
                          _close();
                          setState(() {});
                          if (_route == "address") {
                            _tabController.animateTo(
                              _createAddressStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          } else if (_route == "date") {
                            remoteToDate = false;
                            _tabController.animateTo(
                              _createDateStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }
                          Timer(_duration, () {
                            RxBus.post(_address, tag: "CREATE_ADDRESS");
                          });
                        },
                      ),
                      CreateAddressScreen(
                        taskModel: widget.taskModel,
                        taskId: taskId,
                        nextPage: (String _route) {
                          _close();
                          if (_route == "date") {
                            _tabController.animateTo(
                              _createDateStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      CreateDateScreen(
                        taskId: taskId,
                        nextPage: (String _route, int _price) {
                          _close();
                          if (_route == "budget") {
                            _tabController.animateTo(
                              _createBudgetStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }
                          Timer(_duration, () {
                            RxBus.post(_price, tag: "CREATE_BUGDET");
                          });
                        },
                        taskModel: widget.taskModel,
                      ),
                      CreateBudgetScreen(
                        taskModel: widget.taskModel,
                        taskId: taskId,
                        nextPage: (String _route) {
                          _close();

                          if (_route == "note") {
                            _tabController.animateTo(
                              _createNoteStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      CreateNotesScreen(
                        taskModel: widget.taskModel,
                        taskId: taskId,
                        nextPage: (String _route) {
                          _close();
                          if (_route == "contact") {
                            _tabController.animateTo(
                              _createContactStep,
                              duration: _duration,
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      CreateNumberScreen(
                        taskId: taskId,
                        nextPage: (String _route, String number) {
                          _close();
                          if (_route == "verify") {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return VerificationScreen(
                                  number: number,
                                  update: widget.taskModel != null,
                                  taskModel: widget.taskModel,
                                  taskId: widget.taskModel != null
                                      ? widget.taskModel!.id.toString()
                                      : taskId.toString(),
                                  end: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SuccessScreen(
                                            id: widget.taskModel == null
                                                ? taskId
                                                : widget.taskModel!.id,
                                            edit: widget.taskModel != null,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else if (widget.taskModel != null) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SuccessScreen(
                                    id: widget.taskModel == null
                                        ? taskId
                                        : widget.taskModel!.id,
                                    edit: widget.taskModel != null,
                                  );
                                },
                              ),
                            );
                          } else {
                            if (widget.myTask) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              RxBus.post(true, tag: "RELOAD_MY_TASK");
                            } else {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  if (mounted) {
                                    _close();
                                  }
                                  return SuccessScreen(
                                    id: widget.taskModel == null
                                        ? taskId
                                        : widget.taskModel!.id,
                                    edit: widget.taskModel != null,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        taskModel: widget.taskModel,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _close() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt("id") ?? 0;
    if (mounted) {
      setState(() {});
    }
  }
}
