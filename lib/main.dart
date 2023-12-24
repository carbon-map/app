import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Back',
          onMessageReceived: (JavaScriptMessage message) {
        developer.log('The return value is ${message.message}');
      })
      ..clearCache()
      ..loadRequest(Uri.parse("http://carbon.ccuxvideos.com/"));
    // ..loadRequest(Uri.parse("https://flutter.dev"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: '回到上一頁',
          onPressed: () => controller.runJavaScript('previous()'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.question_mark),
            tooltip: '使用說明',
            onPressed: () => showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AlertDialog(
                  title: const Text("使用教學"),
                  content: const Text("先後點選區域、縣市，再輸入年月，即可獲得碳排放的預測資料。"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("我知道了"),
                    ),
                  ],
                );
              },
              transitionDuration: const Duration(seconds: 1),
              transitionBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FractionalTranslation(
                  // 從底部滑出
                  translation: Offset(0, 1 - animation.value),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
