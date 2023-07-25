import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/more/screens/settings/screens/error_screen.dart';
import 'package:youdu/src/utils/utils.dart';

class CenterDialog {
  static errorDialog(
    BuildContext context,
    String text,
    String response, {
    Function()? onTap,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(
              "create_task.error",
            ),
          ),
          content: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ErrorScreen(
                    error: response,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Text(
                text,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ErrorScreen(
                      error: response,
                    ),
                  ),
                );
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    "Info",
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("ok"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static createTaskDialog(BuildContext context, Function(bool k) onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate("task_create_title"),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                onTap(true);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("yes"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(false);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("no"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static updateAppDialog(BuildContext context, Function(bool k) onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate("update_app_title"),
            textAlign: TextAlign.center,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                onTap(true);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("yes"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(false);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("no"),
                    style: AppTypography.pSmallRedBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static messageDialog(BuildContext context, String text, Function() onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(translate("msg")),
          content: Text(
            text,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("continue"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static selectDialog(
      BuildContext context, String text, Function(bool value) onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate("msg"),
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProduct,
            ),
          ),
          content: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProduct,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                onTap(true);
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("yes"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(false);
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("no"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static selectDialogBlock(
      BuildContext context, String text, Function(bool value) onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            text == 'unblock'
                ? translate("unblock_msg")
                : translate("block_msg"),
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProduct,
            ),
          ),
          content: Text(
            text == 'unblock' ? '' : text,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamilyProduct,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                onTap(true);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("yes"),
                    style: AppTypography.pSmallRedBold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(false);
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    translate("no"),
                    style: AppTypography.pSmallBlueBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static networkErrorDialog(
    BuildContext context, {
    Function()? onTap,
  }) async {
    String txt = await Utils.checkConnection();
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              txt == translate("network_title")
                  ? translate("network_err")
                  : translate(
                      "create_task.error",
                    ),
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProduct,
              ),
            ),
            content: Text(
              txt,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamilyProduct,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap();
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      translate("ok"),
                      style: AppTypography.pSmallBlueBold,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      );
    }
  }
}
