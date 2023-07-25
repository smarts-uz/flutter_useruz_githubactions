import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  late String webViewUrl;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _enableRotation();
    webViewUrl = widget.url;
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: Stack(
        children: [
          loading
              ? Container(
                  color: AppColors.white,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox(),
          Column(
            children: [
              Expanded(
                child: WebView(
                  backgroundColor: Colors.white,
                  gestureNavigationEnabled: true,
                  initialUrl: webViewUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (con) {},
                  onProgress: (pr) {
                    if (pr > 90) {
                      loading = false;
                      setState(() {});
                    }
                  },
                ),
              ),
              AppCustomButton(
                title: translate("my_task.clear"),
                color: AppColors.yellow00,
                margin: const EdgeInsets.only(
                    top: 12, left: 24, bottom: 24, right: 24),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
