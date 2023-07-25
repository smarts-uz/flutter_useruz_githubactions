// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/dialog/bottom_dialog.dart';
import 'package:youdu/src/model/api_model/profile/profile_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/profile/portfolio/portfolio_view_screen.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/profile/profile_widget.dart';
import 'package:youdu/src/widget/profile/completed_work_widget.dart';
import 'package:youdu/src/widget/profile/portfolio_widget.dart';
import 'package:youdu/src/widget/profile/profile_settings_widget.dart';
import 'package:youdu/src/widget/profile/reviews_widget.dart';
import 'package:youdu/src/widget/profile/social_widget.dart';
import 'package:youdu/src/widget/shimmer/profile_shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../bloc/guest/performers/performers_bloc.dart';
import '../../../../../utils/language_performers.dart';
import '../../../../../widget/app/custom_network_image.dart';
import '../../../my_task/item/my_task_item_screen.dart';
import '../../../my_task/product/item/image_view.dart';

class ProfileScreen extends StatefulWidget {
  final int id;
  final bool perform;

  const ProfileScreen({super.key, required this.id, this.perform = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Repository repository = Repository();
  bool isFirst = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  String text = "";
  bool viewC = false;
  int ind = -1;
  int userId = -1;
  bool progress = false, perform = false;
  int realId = 0;

  @override
  void initState() {
    userId = widget.id;
    perform = LanguagePerformers.getRoleId() == 2;
    getData(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PerformersFilterProvider>(context);
    return StreamBuilder(
      stream:
          userId == -1 ? profileBloc.profileInfo : profileBloc.profileInfoUser,
      builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
        if (snapshot.hasData) {
          ProfileModel data = snapshot.data!;
          return CupertinoScaffold(
            body: Builder(
              builder: (context) {
                return CupertinoPageScaffold(
                  backgroundColor: Colors.white,
                  child: Stack(
                    children: [
                      Scaffold(
                        key: _scaffoldKey,
                        resizeToAvoidBottomInset: false,
                        backgroundColor: AppColors.white,
                        appBar: AppBar(
                          backgroundColor: AppColors.white,
                          elevation: 0,
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              color: Colors.transparent,
                              child: SvgPicture.asset(AppAssets.back),
                            ),
                          ),
                          title: Column(
                            children: [
                              Text(
                                data.data.name,
                                style: AppTypography.pSmallRegularDark33Bold,
                              ),
                              Text(
                                data.data.lastSeen.toString(),
                                style: AppTypography.pTinyGreyADMedium,
                              ),
                            ],
                          ),
                          actions: [
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int id = prefs.getInt("id") ?? 0;
                                userId == -1
                                    ? shareLink(id, data.data.name)
                                    : BottomDialog.bottomDialogProfile(
                                        context,
                                        false,
                                        unBlock: data.data.blockedUser == 1,
                                        (id) async {
                                          if (id == 1) {
                                            shareLink(userId, data.data.name);
                                          }
                                          if (id == 2) {
                                            if (data.data.blockedUser == 0) {
                                              CenterDialog.selectDialogBlock(
                                                  context, text, (value) async {
                                                if (value) {
                                                  Navigator.pop(context);
                                                  progress = true;
                                                  setState(() {});
                                                  HttpResult response =
                                                      await Repository()
                                                          .blockUser(widget.id);
                                                  progress = false;
                                                  setState(() {});
                                                  if (response.isSuccess &&
                                                      response.result[
                                                              "success"] ==
                                                          true) {
                                                    performersBloc
                                                        .allPerformers(
                                                            false, 1, context);

                                                    Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst);
                                                  } else if (response.status ==
                                                      -1) {
                                                    CenterDialog.errorDialog(
                                                      context,
                                                      Utils.serverErrorText(
                                                          response),
                                                      response.result
                                                          .toString(),
                                                    );
                                                  } else {
                                                    CenterDialog.errorDialog(
                                                      context,
                                                      Utils.serverErrorText(
                                                          response),
                                                      response.result
                                                          .toString(),
                                                    );
                                                  }
                                                }
                                              });
                                            } else {
                                              progress = true;
                                              setState(() {});
                                              HttpResult response =
                                                  await Repository()
                                                      .blockUser(widget.id);
                                              progress = false;
                                              setState(() {});
                                              if (response.isSuccess &&
                                                  response.result["success"] ==
                                                      true) {
                                                performersBloc.allPerformers(
                                                    false, 1, context);

                                                Navigator.popUntil(context,
                                                    (route) => route.isFirst);
                                              } else if (response.status ==
                                                  -1) {
                                                CenterDialog.errorDialog(
                                                  context,
                                                  Utils.serverErrorText(
                                                      response),
                                                  response.result.toString(),
                                                );
                                              } else {
                                                CenterDialog.errorDialog(
                                                  context,
                                                  Utils.serverErrorText(
                                                      response),
                                                  response.result.toString(),
                                                );
                                              }
                                            }
                                          }
                                          if (id == 0) {
                                            BottomDialog.reportDialog(
                                              context,
                                              userId,
                                            );
                                          }
                                        },
                                      );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                color: Colors.transparent,
                                child: userId == -1
                                    ? SvgPicture.asset(
                                        AppAssets.share,
                                        color: AppColors.yellow00,
                                      )
                                    : RotatedBox(
                                        quarterTurns: 1,
                                        child:
                                            SvgPicture.asset(AppAssets.profile),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        body: RefreshIndicator(
                          onRefresh: restart,
                          color: AppColors.yellow00,
                          backgroundColor: AppColors.white,
                          child: ListView(
                            controller: controller,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 0, left: 16),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        List<String> s = [data.data.avatar];
                                        data.data.avatar.contains('default')
                                            ? () {}
                                            : Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                  child: ImageView(
                                                    data: s,
                                                  ),
                                                ),
                                              );
                                      },
                                      child: SizedBox(
                                        height: 96,
                                        width: 96,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CustomNetworkImage(
                                              image: data.data.avatar,
                                              height: 96,
                                              width: 96,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 150,
                                        // width: 200,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  AppAssets.eye,
                                                  color: AppColors.greyE9,
                                                ),
                                                Text(
                                                  data.data.views.toString(),
                                                  style:
                                                      AppTypography.pTinyGreyE9,
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                              ],
                                            ),
                                            if (viewC)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 16),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: AppColors.dark33
                                                      .withOpacity(0.3),
                                                ),
                                                child: Text(
                                                  text,
                                                  style: const TextStyle(
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              )
                                            else
                                              Container(),
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: data.data
                                                        .achievements.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemBuilder: (_, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (ind == index) {
                                                            viewC = false;
                                                            ind = -1;
                                                          } else {
                                                            viewC = true;
                                                            ind = index;
                                                            text = data
                                                                .data
                                                                .achievements[
                                                                    index]
                                                                .message;
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          height: 42,
                                                          width: 42,
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: data
                                                                .data
                                                                .achievements[
                                                                    index]
                                                                .image,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyTaskItemScreen(
                                              title: translate(
                                                  "profile.task_create"),
                                              status: widget.id == -1 ? 4 : 1,
                                              performer: 0,
                                              perform: false,
                                              performId: 0,
                                              userId: widget.id,
                                              profile: true,
                                              id: userId == -1
                                                  ? realId
                                                  : widget.id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ProfileWidget(
                                      content: translate("profile.task_create"),
                                      title: data.data.createdTasks.toString(),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyTaskItemScreen(
                                              title:
                                                  translate("profile.task_end"),
                                              status: widget.id == -1 ? 4 : 0,
                                              performer: 1,
                                              perform: false,
                                              performId: 0,
                                              userId: widget.id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ProfileWidget(
                                      content: translate("profile.task_end"),
                                      title:
                                          data.data.performedTasks.toString(),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              userId == -1
                                  ? ProfileSettingsWidget(
                                      money: data.data.walletBalance.toString(),
                                      link: data.data.video,
                                      about: data.data.description,
                                      category: data.data.categories,
                                      workExp: data.data.workExp.toString(),
                                      exampleCount: data.data.exampleCount,
                                      onTap: (data,
                                          {List<int> all =
                                              const <int>[]}) async {
                                        if (all.isNotEmpty) {
                                          setState(() {});
                                          HttpResult response =
                                              await repository.changeCategory(
                                            1,
                                            1,
                                            all,
                                          );
                                          profileBloc
                                              .getProfile(userId, context)
                                              .then((value) {
                                            provider.updateLoading(false);
                                            Navigator.pop(context);

                                            if (response.isSuccess) {
                                              if (response.result["success"] ==
                                                  true) {
                                                // ignore: deprecated_member_use
                                                CenterDialog.messageDialog(
                                                  context,
                                                  response.result["data"]
                                                          ["message"]
                                                      .toString(),
                                                  () {},
                                                );
                                              } else {
                                                // ignore: deprecated_member_use
                                                CenterDialog.errorDialog(
                                                  context,
                                                  response.result["messages"]
                                                      .toString(),
                                                  response.result["messages"]
                                                      .toString(),
                                                );
                                              }
                                            } else if (response.status == -1) {
                                              CenterDialog.networkErrorDialog(
                                                  context);
                                            }
                                          });
                                        } else {
                                          setState(() {});
                                          List<int> category = [];
                                          for (int i = 0;
                                              i < data.length;
                                              i++) {
                                            for (int j = 0;
                                                j < data[i].chooseItem.length;
                                                j++) {
                                              category.add(
                                                  data[i].chooseItem[j].id);
                                            }
                                          }

                                          HttpResult response =
                                              await repository.changeCategory(
                                            1,
                                            1,
                                            category,
                                          );
                                          profileBloc
                                              .getProfile(userId, context)
                                              .then((value) {
                                            provider.updateLoading(false);
                                            Navigator.pop(context);

                                            if (response.isSuccess) {
                                              if (response.result["success"] ==
                                                  true) {
                                                // ignore: deprecated_member_use
                                                CenterDialog.messageDialog(
                                                  context,
                                                  response.result["data"]
                                                          ["message"]
                                                      .toString(),
                                                  () {},
                                                );
                                              } else {
                                                // ignore: deprecated_member_use
                                                CenterDialog.errorDialog(
                                                  context,
                                                  response.result["messages"]
                                                      .toString(),
                                                  response.result["messages"]
                                                      .toString(),
                                                );
                                              }
                                            } else if (response.status == -1) {
                                              CenterDialog.networkErrorDialog(
                                                  context);
                                            }
                                          });
                                        }
                                      },
                                      onScale: () {
                                        provider.updateLoading(false);
                                        Navigator.pop(context);
                                        controller.animateTo(290,
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            curve: Curves.linear);
                                      },
                                      perform: perform,
                                    )
                                  : Container(),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Text(
                                  translate("profile.description"),
                                  style: AppTypography.h2SmallDark33Medium,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "${data.data.age == 0 ? "" : data.data.age}${translate("profile.year1")}, ${data.data.location}",
                                  style: AppTypography.pTinyGrey94,
                                ),
                              ),
                              data.data.workExp != 0
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        "${translate("profile.work_exp_view")} ${data.data.workExp} ${translate("profile.exp_year")}",
                                        style: AppTypography.pTinyGrey94,
                                      ),
                                    )
                                  : const SizedBox(),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "${translate("profile.user")} ${Utils.dateNameFormatCreateDate(data.data.createdAt)}.",
                                  style: AppTypography.pTinyGrey94,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Text(
                                  data.data.description,
                                  style: AppTypography.pTinyDark33Normal,
                                ),
                              ),
                              data.data.video.split("/").last != ""
                                  ? Container(
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 20,
                                          bottom: 32),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: YoutubePlayer(
                                          liveUIColor: Colors.redAccent,
                                          controller: YoutubePlayerController(
                                            initialVideoId:
                                                data.data.video.split("/").last,
                                            flags: const YoutubePlayerFlags(
                                              isLive: false,
                                              autoPlay: false,
                                              hideThumbnail: true,
                                            ),
                                          ),
                                          bottomActions: const [],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 15,
                                    ),
                              PortfolioWidget(
                                data: data.data.portfolios,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PortfolioViewScreen(
                                        id: userId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ReviewsWidget(
                                good: data.data.reviews.reviewGood,
                                bad: data.data.reviews.reviewBad,
                                star: data.data.reviews.rating,
                                description:
                                    data.data.reviews.lastReview.description,
                                name: data.data.reviews.lastReview.reviewerName,
                                user: userId,
                              ),
                              !perform
                                  ? Container()
                                  : CompletedWorkWidget(
                                      tasksCount: data.data.tasksCount,
                                    ),
                              const SizedBox(
                                height: 40,
                              ),
                              SocialWidget(
                                data: data,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      !progress
                          ? Container()
                          : Scaffold(
                              body: Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator
                                              .adaptive(
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
                              ),
                            )
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return ProfileShimmer(
            id: userId,
          );
        }
      },
    );
  }

  Future<bool> restart() async {
    await profileBloc.getProfile(userId, context);
    return true;
  }

  getData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int k = prefs.getInt("id") ?? 0;
    realId = k;
    userId = id == k ? -1 : id;
    profileBloc.getProfile(userId, context);
    setState(() {});
  }

  shareLink(int id, String name) {
    Share.share("${translate("profile.share")} $name"
        "\n\n\nhttps://user.uz/performers/$id \n\n ");
  }
}
