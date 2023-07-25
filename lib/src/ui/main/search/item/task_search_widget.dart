// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/utils/utils.dart';

class TaskSearchWidget extends StatefulWidget {
  final Function(String text) onTap;
  final String text;
  final bool isPerformer;

  const TaskSearchWidget({
    super.key,
    required this.onTap,
    required this.text,
    this.isPerformer = false,
  });

  @override
  State<TaskSearchWidget> createState() => _TaskSearchWidgetState();
}

class _TaskSearchWidgetState extends State<TaskSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final Duration _duration = const Duration(milliseconds: 600);
  bool animation = false, text = false;
  List<String> data = [];

  @override
  void initState() {
    _controller.text = widget.text;
    setState(() {});
    _controller.addListener(() {
      setState(() {});
    });
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 12,
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: _duration,
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(
                      left: 16,
                    ),
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: AppColors.greyF4,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.search,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            controller: _controller,
                            textInputAction: TextInputAction.search,
                            onFieldSubmitted: (e) async {
                              if (e.trim() != "") {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                bool add = true;
                                for (int i = 0; i < data.length; i++) {
                                  if (data[i] == e) {
                                    add = false;
                                  }
                                }
                                if (add) {
                                  data.add(e);
                                }
                                prefs.setStringList(
                                    widget.isPerformer
                                        ? "save_search_performers"
                                        : "save_search",
                                    data);
                                widget.onTap(e);
                                Navigator.pop(context);
                              } else if (_controller.text == "") {
                                widget.onTap("");
                                Navigator.pop(context);
                              } else {
                                widget.onTap("");
                                Navigator.pop(context);
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffix: _controller.text == ""
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        _controller.text = "";
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 16,
                                        width: 16,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              AppColors.dark00.withOpacity(0.5),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close,
                                            color: AppColors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                              hintText: text
                                  ? translate("create_task.help")
                                  : translate("search.search"),
                              hintStyle: AppTypography.pSmallGrey85,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Utils.close(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 78,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        translate("create_task.break"),
                        style: AppTypography.pTinyYellow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Utils.close(context);
                      // print(_controller.text);
                      widget.onTap(data[index]);
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Text(
                                  data[index],
                                  style: AppTypography.pSmall3Dark33H,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  data.removeAt(index);
                                  prefs.setStringList(
                                      widget.isPerformer
                                          ? "save_search_performers"
                                          : "save_search",
                                      data);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                                color: AppColors.dark6A,
                                iconSize: 22,
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0, left: 16),
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.greyE9,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = prefs.getStringList(
            widget.isPerformer ? "save_search_performers" : "save_search") ??
        [];
    setState(() {});
  }
}
