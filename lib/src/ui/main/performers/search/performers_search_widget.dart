import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/performers/filter/filter_provider/performers_provider.dart';
import 'package:youdu/src/ui/main/search/item/task_search_widget.dart';
import 'package:youdu/src/utils/rx_bus.dart';

class PerformersSearchWidget extends StatefulWidget {
  final EdgeInsets margin;
  final String text;
  final Color color;
  final TextEditingController controller;

  const PerformersSearchWidget({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    required this.text,
    required this.controller,
    this.color = AppColors.greyF4,
  });

  @override
  State<PerformersSearchWidget> createState() => _PerformersSearchWidgetState();
}

class _PerformersSearchWidgetState extends State<PerformersSearchWidget> {
  bool get = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PerformersFilterProvider>(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(22),
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
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskSearchWidget(
                      isPerformer: true,
                      onTap: (k) {
                        widget.controller.text = k;
                        if (k == "") {
                          get = false;
                          provider.updateSearch(k);
                          RxBus.post("", tag: "SEARCH_PERFORMER_EVENT");
                        } else {
                          get = true;
                          provider.updateSearch(k);
                          RxBus.post(k, tag: "SEARCH_PERFORMER_EVENT");
                        }
                      },
                      text: widget.controller.text,
                    ),
                  ),
                );
              },
              style: AppTypography.pSmallRegular.copyWith(color: null),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.text,
                suffix: widget.controller.text == ""
                    ? null
                    : GestureDetector(
                        onTap: () {
                          widget.controller.text = "";
                          provider.updateSearch("");
                          get = false;
                          RxBus.post("", tag: "SEARCH_PERFORMER_EVENT");
                        },
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: AppColors.dark00.withOpacity(0.5),
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
                hintStyle: AppTypography.pSmallRegular.copyWith(
                  color: AppColors.grey85,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
