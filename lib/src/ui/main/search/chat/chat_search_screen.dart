import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/chat/chat_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/chat/chat_search_model.dart';
import 'package:youdu/src/ui/main/search/chat/chat_item_screen.dart';
import 'package:youdu/src/widget/app/custom_network_image.dart';

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    chatBloc.allChatSearch("");
    _controller.addListener(() {
      chatBloc.allChatSearch(_controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(44),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              SvgPicture.asset(
                AppAssets.search,
                height: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: AppTypography.pSmallRegular.copyWith(
                    color: AppColors.dark00,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: translate("chat.search"),
                    hintStyle: AppTypography.pSmallRegular.copyWith(
                      color: const Color(0xFF808185),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                translate("create_task.break"),
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamilyProduct,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFFEC7E00),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<SearchResult>>(
          stream: chatBloc.getChatSearch,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SearchResult> data = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 16,
                  left: 16,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatItemScreen(
                              id: data[index].id,
                              name: data[index].name,
                              avatar: data[index].avatar,
                              time: "",
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ClipRRect(
                                // ignore: sort_child_properties_last
                                child: CustomNetworkImage(
                                  image: data[index].avatar,
                                  height: 48,
                                  width: 48,
                                ),
                                borderRadius: BorderRadius.circular(48),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  data[index].name,
                                  style: AppTypography.pSmall1Dark00SemiBold,
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
              );
            }
            return Container();
          }),
    );
  }
}
