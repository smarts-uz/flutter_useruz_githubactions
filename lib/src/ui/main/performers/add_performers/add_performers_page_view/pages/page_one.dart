// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/lib/flutter_datetime_picker.dart';
import 'package:youdu/src/utils/lib/src/i18n_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

class PageOne extends StatefulWidget {
  final Function() onTap;

  const PageOne({super.key, required this.onTap});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  Repository repository = Repository();
  bool loading = false, errorCity = false, errorBirthday = false;
  DateTime? bornDate;
  String selectedValue = translate("citys.city");
  String? errorBirthdayS, errorCityS;

  List<String> city = [
    translate("citys.tashkent"),
    translate("citys.namangan"),
    translate("citys.fargona"),
    translate("citys.andijon"),
    translate("citys.sirdaryo"),
    translate("citys.navoiy"),
    translate("citys.samarqand"),
    translate("citys.qashqadaryo"),
    translate("citys.surhondaryo"),
    translate("citys.jizzah"),
    translate("citys.buxoro"),
    translate("citys.xorazim"),
    translate("citys.qoraqalpoq"),
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.one.title1"),
              style: AppTypography.pSmallRegularDark33.copyWith(
                fontFamily: AppTypography.fontFamilyProxima,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              translate("performers.one.title2"),
              style: AppTypography.pSmall3Dark33,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              controller: nameController,
              maxLength: 70,
              keyboardType: TextInputType.text,
              style: AppTypography.pSmall3Dark33,
              cursorColor: AppColors.greyAD,
              decoration: InputDecoration(
                counterText: "",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.dark33,
                  ),
                ),
                labelText: translate("auth.full_name"),
                labelStyle: AppTypography.pSmall3,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorText: errorCityS,
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: errorCityS != null
                            ? AppColors.red5B
                            : AppColors.dark33,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<List<String>>(
                      dropdownColor: Colors.white,
                      style: AppTypography.pSmallBlack,
                      hint: Text(
                        selectedValue,
                        style: AppTypography.pSmallBlack,
                      ),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (List<String>? newValue) {},
                      items: city.map<DropdownMenuItem<List<String>>>(
                        (String valueItem) {
                          return DropdownMenuItem(
                            onTap: () {
                              errorCityS = null;
                              errorCity = false;
                              selectedValue = valueItem;
                              setState(() {});
                            },
                            value: city,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  valueItem,
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: birthdayController,
              readOnly: true,
              style: AppTypography.pSmall3Dark33,
              onTap: () {
                errorBirthdayS = null;
                errorBirthday = false;
                setState(() {});
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 02, 16),
                  maxTime: DateTime(DateTime.now().year - 18, 12, 31),
                  onConfirm: (date) {
                    bornDate = date;
                    birthdayController.text =
                        "${Utils.numberFormat(bornDate!.day)}.${Utils.numberFormat(bornDate!.month)}.${bornDate!.year}";
                    setState(() {});
                  },
                  locale: (LanguagePerformers.getLanguage() == "ru")
                      ? LocaleType.ru
                      : LocaleType.uz,
                  currentTime: bornDate ?? DateTime.now(),
                );
              },
              decoration: InputDecoration(
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: errorBirthdayS != null
                        ? AppColors.red5B
                        : AppColors.dark33,
                  ),
                ),
                errorText: errorBirthdayS,
                labelText: translate("more.birthday"),
                labelStyle: AppTypography.pSmall3,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: YellowButton(
        text: translate("profile.next"),
        loading: loading,
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (bornDate != null && selectedValue != translate("citys.city")) {
            loading = true;
            setState(() {});
            HttpResult response = await repository.initialData(
              nameController.text,
              selectedValue,
              "${bornDate!.year}-${Utils.numberFormat(bornDate!.month)}-${Utils.numberFormat(bornDate!.day)}",
            );
            loading = false;
            setState(() {});
            if (response.isSuccess) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (response.result["success"] == "true") {
                prefs.setString("name", nameController.text);
                widget.onTap();
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
            } else {
              if (response.status == -1) {
                CenterDialog.networkErrorDialog(context);
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
            }
          } else {
            if (bornDate == null) {
              errorBirthday = true;
              errorBirthdayS = LanguagePerformers.getLanguage() == "ru"
                  ? translate("err_msg") + translate("more.birthday")
                  : translate("more.birthday") + translate("err_msg");
            }
            if (selectedValue == translate("citys.city")) {
              errorCity = true;
              errorCityS = LanguagePerformers.getLanguage() == "ru"
                  ? translate("err_msg") + translate("citys.city")
                  : translate("citys.city") + translate("err_msg");
            }
            setState(() {});
          }
        },
        margin: EdgeInsets.only(
          left: 48,
          right: 16,
          bottom: Platform.isIOS ? 24 : 16,
        ),
      ),
    );
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nameController.text = pref.getString("name") ?? "";
    setState(() {});
  }
}
