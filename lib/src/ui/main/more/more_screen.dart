import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/main_screen.dart';
import 'package:youdu/src/ui/main/more/screens/about_app/about_app_screen.dart';
import 'package:youdu/src/ui/main/more/screens/news/news_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/balance/balance_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/balance/paynet_screen.dart';
import 'package:youdu/src/ui/main/more/screens/profile/profile_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/settings_screen.dart';
import 'package:youdu/src/ui/main/more/screens/support/support_screen.dart';
import 'package:youdu/src/ui/main/performers/add_performers/main_view_screen.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';
import 'package:youdu/src/widget/button/border_button.dart';
import 'package:youdu/src/widget/more/more_widget.dart';
import 'package:youdu/src/widget/shimmer/more_screen_shimmer.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String name = translate("performers.unknown");
  String image = "";
  String balance = "0";
  int id = 0;

  int sId = 0;
  String sName = "", sAvatar = "";

  @override
  void initState() {
    _rxCall();
    _getData();
    getSupport();
    profileBloc.getProfile(-1, context);
    super.initState();
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "CHANGE_IMAGE_NAME");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                backgroundColor: AppColors.white,
                elevation: 0,
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: SvgPicture.asset(AppAssets.settings),
                    ),
                  ),
                ],
              ),
              body: FutureBuilder<HttpResult>(
                  future: Repository().getAllSettings(),
                  builder: (context, AsyncSnapshot<HttpResult> snapshot) {
                    if (snapshot.hasData) {
                      List notSorted = [];
                      if (snapshot.data!.result["data"] != null) {
                        notSorted = snapshot.data!.result["data"].map((e) {
                          if (e["key"] == "site.instagram_url" ||
                              e["key"] == "site.telegram_url" ||
                              e["key"] == "site.facebook_url") {
                            return e["value"].toString();
                          }
                        }).toList();
                      }

                      notSorted.removeWhere((element) => element == null);
                      List<String> data = List.from(notSorted);
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  top: 28, left: 16, right: 16),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 8),
                                    blurRadius: 32,
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 39, bottom: 8),
                                          child: Text(
                                            name,
                                            style: AppTypography
                                                .h2SmallDark33Medium,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onLongPress: () {
                                                  Clipboard.setData(
                                                          ClipboardData(
                                                              text: id
                                                                  .toString()))
                                                      .then(
                                                    (value) {
                                                      Fluttertoast.showToast(
                                                        msg: translate("copy"),
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
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  translate("profile.id"),
                                                  style: TextStyle(
                                                    fontFamily: AppTypography
                                                        .fontFamilyProduct,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    height: 22 / 15,
                                                    color: AppColors.dark33
                                                        .withOpacity(.5),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onLongPress: () {
                                                  Clipboard.setData(
                                                          ClipboardData(
                                                              text: id
                                                                  .toString()))
                                                      .then(
                                                    (value) {
                                                      Fluttertoast.showToast(
                                                        msg: translate("copy"),
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
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  " $id",
                                                  style: const TextStyle(
                                                    fontFamily: AppTypography
                                                        .fontFamilyProduct,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    height: 22 / 15,
                                                    color: AppColors.dark33,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                            ClipboardData(
                                                                text: id
                                                                    .toString()))
                                                        .then(
                                                      (value) {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              translate("copy"),
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.copy_rounded,
                                                    color: AppColors.dark33
                                                        .withOpacity(.5),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BalanceScreen(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 39, bottom: 0),
                                                child: Text(
                                                  translate("profile.account"),
                                                  style: AppTypography
                                                      .pTiny215YellowNormal,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 39, bottom: 8),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${priceFormat.format(int.parse(balance))} ${translate("sum")}",
                                                    style: AppTypography
                                                        .pTiny215YellowNormal,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      CupertinoScaffold
                                                          .showCupertinoModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return const PaynetScreen();
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      color: Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        AppAssets.addLocation,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 72,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(72),
                                      color: AppColors.yellow00,
                                    ),
                                    child: image != ""
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CustomNetworkImage(
                                              height: 72,
                                              width: 72,
                                              image: image,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.person,
                                              size: 48,
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            MoreWidget(
                              title: translate("profile.profile"),
                              icon: AppAssets.profileIcon,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      id: -1,
                                      perform:
                                          LanguagePerformers.getRoleId() == 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MoreWidget(
                              title: translate("profile.news"),
                              icon: AppAssets.news,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NewsScreen(),
                                  ),
                                );
                              },
                            ),
                            MoreWidget(
                              title: translate("more.support"),
                              icon: AppAssets.headphones,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SupportScreen(),
                                  ),
                                );
                              },
                            ),
                            MoreWidget(
                              title: translate("more.about"),
                              icon: AppAssets.hash,
                              onTap: data.isEmpty
                                  ? () {}
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AboutAppSCreen(data: data),
                                        ),
                                      );
                                    },
                            ),
                            // const Spacer(),
                            const SizedBox(height: 72),
                            Container(),
                            LanguagePerformers.getRoleId() == 2
                                ? Container()
                                : BorderButton(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainViewScreen(),
                                        ),
                                      );
                                    },
                                    text: translate("profile.want_performer"),
                                    txtColor: AppColors.yellow00,
                                  ),
                            const SizedBox(
                              height: 32,
                            )
                          ],
                        ),
                      );
                    } else {
                      return const MoreScreenShimmer();
                    }
                  }),
            ),
          );
        },
      ),
    );
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString("image") ?? "";
    name = prefs.getString("name") ?? "Unknown";
    balance = prefs.getInt("balance").toString();
    id = prefs.getInt("id") ?? 0;
    if (mounted) {
      setState(() {});
    }
  }

  getSupport() async {
    HttpResult response = await Repository().getSupport();

    if (response.isSuccess) {
      sId = int.parse(response.result["data"]["id"].toString());
      sName = response.result["data"]["name"];
      sAvatar = response.result["data"]["avatar"];
      setState(() {});
    }
  }

  _rxCall() {
    RxBus.register<String>(tag: "CHANGE_IMAGE_NAME").listen((event) {
      _getData();
    });
  }
}
