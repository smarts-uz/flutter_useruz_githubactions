import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youdu/src/constants/constants.dart';

class ProfileTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final EdgeInsets margin;

  final String? error;
  final int maxLength;
  final TextInputType type;
  final int maxL;

  final List<TextInputFormatter> textFormatters;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.text,
    this.maxL = 0,
    this.textFormatters = const <TextInputFormatter>[],
    this.margin = const EdgeInsets.only(
      top: 16,
      left: 16,
      right: 16,
    ),
    this.type = TextInputType.text,
    this.maxLength = 1,
    this.error = "",
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.text,
            textAlign: TextAlign.start,
            style: AppTypography.pGrey97,
          ),
          TextField(
            showCursor: true,
            controller: widget.controller,
            maxLines: widget.maxLength,
            keyboardType: widget.type,
            inputFormatters: widget.textFormatters,
            maxLength: widget.maxL != 0 ? widget.maxL : null,
            style: AppTypography.pSmall3Dark33,
            cursorColor: AppColors.greyAD,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.dark33,
                ),
              ),
              labelStyle: AppTypography.pSmall3,
              errorText: widget.error,
              errorStyle: AppTypography.pSmallRedB5,
              suffixIcon: widget.controller.text == ""
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.controller.clear();
                        });
                      },
                      child: Container(
                        width: 48,
                        color: Colors.transparent,
                        child: const Center(
                            child: Center(
                          child: Icon(
                            Icons.close,
                            color: AppColors.dark33,
                            size: 24,
                          ),
                        )),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
