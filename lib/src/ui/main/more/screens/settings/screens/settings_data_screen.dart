// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/profile/profile_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api_model/profile/settings_data_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/change_email_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/change_phone_screen.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/image_crope.dart';
import 'package:youdu/src/utils/language_performers.dart';
import 'package:youdu/src/utils/lib/flutter_datetime_picker.dart';
import 'package:youdu/src/utils/lib/src/i18n_model.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/back_widget.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';
import 'package:youdu/src/widget/more/settings/settings_data_widget.dart';
import 'package:youdu/src/widget/shimmer/settings_shimmer.dart';

class SettingsDataScreens extends StatefulWidget {
  const SettingsDataScreens({super.key});

  @override
  State<SettingsDataScreens> createState() => _SettingsDataScreensState();
}

class _SettingsDataScreensState extends State<SettingsDataScreens> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Repository repository = Repository();
  DateTime? bornDate;
  bool loading = false;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool wait = false;
  int roleId = 5;
  int sex = 0;
  bool isFirst = false;
  String selectedValue = "";

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
    selectedValue = translate("citys.city");
    _getData();
    profileBloc.getSettingsData(context);
    nameController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    });
    super.initState();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roleId = prefs.getInt("roleId") ?? 5;
    setState(() {});
  }

  void showBottomSheet(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext ctx) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        leading: const BackWidget(),
        title: Text(
          translate("more.personal_info"),
          style: AppTypography.pSmallRegularDark33Bold,
        ),
      ),
      body: StreamBuilder(
        stream: profileBloc.settingsData,
        builder: (context, AsyncSnapshot<SettingsDataModel> snapshot) {
          if (snapshot.hasData) {
            SettingsDataModel data = snapshot.data!;
            if (!isFirst) {
              nameController.text = data.data.name;
              cityController.text = data.data.location;
              bornDate = data.data.dateOfBirth;
              birthdayController.text = data.data.dateOfBirth == null
                  ? ""
                  : "${Utils.numberFormat(data.data.dateOfBirth!.day)}.${Utils.numberFormat(data.data.dateOfBirth!.month)}.${data.data.dateOfBirth!.year}";
              mailController.text = data.data.email;
              genderController.text = data.data.gender == 1
                  ? translate("more.male")
                  : translate("more.woman");
              sex = data.data.gender;
              phoneController.text = data.data.phone.isNotEmpty
                  ? !data.data.phone.contains("+")
                      ? "+" + data.data.phone
                      : data.data.phone
                  : "";
              selectedValue = data.data.location;
              isFirst = true;
            }
            return Scaffold(
              body: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 120,
                                  color: AppColors.white,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          PickedFile? pickedFile =
                                              await _picker.getImage(
                                            source: ImageSource.gallery,
                                          );
                                          if (pickedFile != null) {
                                            _imageFile = XFile(pickedFile.path);
                                            setData();
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: AppColors.white,
                                          child: const Center(
                                            child: Text(
                                              "Gallery",
                                              style: AppTypography.pSmallMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 1,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color:
                                            AppColors.dark00.withOpacity(0.6),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          PickedFile? pickedFile =
                                              await _picker.getImage(
                                            source: ImageSource.camera,
                                          );
                                          if (pickedFile != null) {
                                            _imageFile = XFile(pickedFile.path);
                                            setData();
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: AppColors.white,
                                          child: const Center(
                                            child: Text(
                                              "Camera",
                                              style: AppTypography.pSmallMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin:
                                  const EdgeInsets.only(top: 24, bottom: 32),
                              decoration: BoxDecoration(
                                color: AppColors.yellow00,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: "https://user.uz/storage/" +
                                      data.data.avatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            wait
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    margin: const EdgeInsets.only(
                                        top: 24, bottom: 32),
                                    decoration: BoxDecoration(
                                      color: AppColors.dark33.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.yellow00,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SettingsDataWidget(
                    controller: nameController,
                    label: translate("more.full_name"),
                    icon: roleId == 2 ? AppAssets.locked : "",
                    read: roleId == 2,
                  ),
                  genderSelect([
                    CustomFieldType(
                        id: 0,
                        selected: sex == 0 ? true : false,
                        value: translate("more.male")),
                    CustomFieldType(
                        id: 1,
                        selected: sex == 1 ? true : false,
                        value: translate("more.woman")),
                  ]),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            label: Text(
                              translate("citys.city"),
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
                  SettingsDataWidget(
                    controller: birthdayController,
                    label: translate("more.birthday"),
                    icon: roleId == 2 ? AppAssets.locked : "",
                    onTap: () {
                      if (roleId != 2) {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 02, 16),
                          maxTime: DateTime(DateTime.now().year - 18, 12, 31),
                          locale: (LanguagePerformers.getLanguage() == "ru")
                              ? LocaleType.ru
                              : LocaleType.uz,
                          onConfirm: (date) {
                            bornDate = date;
                            birthdayController.text =
                                "${Utils.numberFormat(bornDate!.day)}.${Utils.numberFormat(bornDate!.month)}.${bornDate!.year}";
                            setState(() {});
                          },
                        );
                      }
                    },
                    read: true,
                  ),
                  SettingsDataWidget(
                    controller: phoneController,
                    label: translate("more.number_phone"),
                    icon: AppAssets.arrowRight,
                    read: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePhoneScreen(
                            phone: phoneController.text,
                          ),
                        ),
                      );
                    },
                  ),
                  SettingsDataWidget(
                    controller: mailController,
                    label: translate("more.email"),
                    icon: AppAssets.arrowRight,
                    read: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeEmailScreen(email: mailController.text),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
              floatingActionButton: YellowButton(
                margin: const EdgeInsets.only(right: 16, left: 48),
                loading: loading,
                color: AppColors.yellow16,
                text: translate("more.save"),
                onTap: updateProfile,
              ),
            );
          } else {
            return const SettingsShimmer();
          }
        },
      ),
    );
  }

  updateProfile() async {
    setState(() {
      loading = true;
    });

    HttpResult response = await repository.updateSettings(
      mailController.text,
      getAge(),
      selectedValue,
      sex,
      bornDate ?? DateTime.now(),
      nameController.text,
    );

    if (response.isSuccess) {
      profileBloc.getProfile(-1, context).then((value) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: translate("data_saved"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
      setState(() {});
    } else {
      setState(() {
        loading = false;
      });
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
  }

  setData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCrop(
          image: _imageFile!.path,
          onTap: (String img) async {
            setState(() {
              wait = true;
            });
            HttpResult response = await repository.changeImage(
                XFile(img), "profile/settings/change-avatar");
            setState(() {
              wait = false;
            });
            if (response.isSuccess) {
              profileBloc.getProfile(-1, context);
              profileBloc.getSettingsData(context);
            }
            if (response.status == -1) {
              CenterDialog.networkErrorDialog(context);
            }

            setState(() {});
          },
        ),
      ),
    );
  }

  int getAge() {
    try {
      int date = int.parse(birthdayController.text.split(".").last);
      return (DateTime.now().year - date);
    } catch (_) {
      return 0;
    }
  }

  Widget genderSelect(List<CustomFieldType> options) {
    String chooseData = "";
    int selectedIndex = 0;
    for (int i = 0; i < options.length; i++) {
      if (options[i].selected) {
        chooseData = options[i].value;
      } else {
        chooseData = options[0].value;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            translate("more.sex"),
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProxima,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 22 / 15,
              color: AppColors.greyAD,
            ),
          ),
          InkWell(
            onTap: () => showBottomSheet(
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          translate('cancel'),
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            color: AppColors.grey85,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            chooseData = options[selectedIndex].value;
                            genderController.text = chooseData;
                            sex = sex == 1 ? 0 : 1;
                            setState(() {});
                          });
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          translate('confirm'),
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamilyProxima,
                            color: AppColors.blueE6,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 35,
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int index) {
                        selectedIndex = index;
                      },
                      children:
                          List<Widget>.generate(options.length, (int index) {
                        return Center(
                          child: Text(
                            options[index].value,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    genderController.text,
                    style: AppTypography.pSmall3Dark00,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 19,
                    color: AppColors.yellow16,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.greyAD,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
