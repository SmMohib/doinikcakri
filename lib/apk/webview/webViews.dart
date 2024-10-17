import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  WebViewApp({super.key,this.webmodel});
  Product? webmodel;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  bool isLoading = true;  // To track the loading state

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.webmodel!.applyLink)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.webmodel!.applyLink),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: isLoading
      //       ? const PreferredSize(
      //           preferredSize: Size(double.infinity, 4.0),
      //           child: LinearProgressIndicator(),  // Progress bar
      //         )
      //       : null,
      // appBar: AppBar(
      //   title: const Text(''),
      //   bottom: isLoading
      //       ? const PreferredSize(
      //           preferredSize: Size(double.infinity, 4.0),
      //           child: LinearProgressIndicator(),  // Progress bar
      //         )
      //       : null,
      // ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),  // Circular progress indicator
            ),
        ],
      ),
    );
  }
}
