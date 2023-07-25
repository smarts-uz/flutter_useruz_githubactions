import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/profile/blocked_users_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/blocked_user_model.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/performers/blocked_users_widget.dart';
import 'package:youdu/src/widget/shimmer/search_shimmer.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final bool view = false;

  @override
  void initState() {
    blockedUsersBloc.allBlockedusers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: const BackWidget(),
        title: Text(
          translate("blocked_users"),
          style: AppTypography.pSmall1,
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<AllBlockedusersModel>(
            stream: blockedUsersBloc.getBlockedUsersList,
            builder: (context, AsyncSnapshot<AllBlockedusersModel> snapshot) {
              if (snapshot.hasData) {
                AllBlockedusersModel data = snapshot.data!;
                return Column(children: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.greyE9,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.data.length,
                      itemBuilder: (context, index) {
                        return BlockeduserWidget(
                          onTap: () {},
                          id: data.data[index].blockeduser.id,
                          data: data.data[index].blockeduser,
                        );
                      },
                    ),
                  ),
                ]);
              } else {
                return const SearchShimmer();
              }
            },
          ),
          !view
              ? Container()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.dark00.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
