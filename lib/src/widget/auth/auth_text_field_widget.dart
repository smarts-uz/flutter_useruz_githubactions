import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class AuthTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final EdgeInsets margin;
  final bool isPassword;
  final String? error;
  final int maxLength;
  final TextInputType type;
  final bool price;
  final bool isAuth;
  final List<TextInputFormatter> textFormatters;
  final Function? onSubmitted;
  final Function? onEditingComplete;

  const AuthTextFieldWidget({
    super.key,
    required this.controller,
    required this.text,
    this.isPassword = false,
    this.textFormatters = const <TextInputFormatter>[],
    this.margin = const EdgeInsets.only(
      top: 16,
      left: 16,
      right: 16,
    ),
    this.isAuth = true,
    this.type = TextInputType.text,
    this.maxLength = 1,
    this.error = "",
    this.price = false,
    this.onSubmitted,
    this.onEditingComplete,
  });

  @override
  State<AuthTextFieldWidget> createState() => _AuthTextFieldWidgetState();
}

class _AuthTextFieldWidgetState extends State<AuthTextFieldWidget> {
  bool _obscurePassword = false;

  @override
  void initState() {
    if (widget.isPassword) {
      _obscurePassword = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          !widget.isAuth
              ? Text(
                  widget.text,
                  textAlign: TextAlign.start,
                  style: AppTypography.pGrey97,
                )
              : const SizedBox(),
          TextField(
            showCursor: true,
            obscureText: _obscurePassword,
            controller: widget.controller,
            maxLines: widget.maxLength,
            keyboardType: widget.type,
            inputFormatters: widget.textFormatters,
            onChanged: widget.onSubmitted != null
                ? (value) => widget.onSubmitted!(value)
                : null,
            style: AppTypography.pSmall3Dark33,
            cursorColor: AppColors.greyAD,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.dark33,
                ),
              ),
              labelText: widget.isAuth ? widget.text : null,
              labelStyle: AppTypography.pSmall3,
              errorText: widget.error,
              errorStyle: AppTypography.pSmallRedB5,
              suffixIcon: !widget.isPassword
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Container(
                        width: 48,
                        color: Colors.transparent,
                        child: Center(
                          child: SvgPicture.asset(
                            _obscurePassword == true
                                ? AppAssets.eyeClosed
                                : AppAssets.eye,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
