// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';

class CheckBoxWidget extends StatefulWidget {
  final List<CustomFieldType> options;
  final Function(List<CustomFieldType> _options) choose;

  const CheckBoxWidget({
    super.key,
    required this.options,
    required this.choose,
  });

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.options[index].selected = !widget.options[index].selected;
              widget.choose(widget.options);
            });
          },
          child: Container(
            height: 44,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.options[index].value,
                    style: AppTypography.pTiny2Dark00,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 370),
                  curve: Curves.easeInOut,
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: widget.options[index].selected
                        ? AppColors.yellow00
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.yellow00,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(AppAssets.checkWhite, height: 10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: widget.options.length,
    );
  }
}
