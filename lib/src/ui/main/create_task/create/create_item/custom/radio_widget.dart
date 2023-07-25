import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';

class RadioWidget extends StatefulWidget {
  final List<CustomFieldType> options;
  final Function(String options) choose;
  const RadioWidget({
    super.key,
    required this.options,
    required this.choose,
  });
  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  String chooseData = "";
  int selectedIndex = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.options.length; i++) {
      if (widget.options[i].selected) {
        chooseData = widget.options[i].value;
      }
    }
    widget.choose(chooseData);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              chooseData = widget.options[index].value;
              widget.choose(chooseData);
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
                    borderRadius: BorderRadius.circular(24),
                    color: widget.options[index].value == chooseData
                        ? AppColors.yellow00
                        : AppColors.white,
                    border: Border.all(
                      color: widget.options[index].value == chooseData
                          ? AppColors.yellow00
                          : AppColors.greyD6,
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
