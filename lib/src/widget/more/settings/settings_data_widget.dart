import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youdu/src/constants/constants.dart';

class SettingsDataWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String icon;
  final bool read;
  final Function()? onTap;

  const SettingsDataWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.read,
    this.onTap,
    this.icon = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLength: 70,
        onTap: () {
          onTap!();
        },
        readOnly: read,
        cursorColor: AppColors.yellow00,
        decoration: InputDecoration(
          labelText: label,
          counterText: "",
          labelStyle: AppTypography.pTiny215ProGreyAD,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.yellow00,
            ),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(icon),
          ),
        ),
      ),
    );
  }
}
