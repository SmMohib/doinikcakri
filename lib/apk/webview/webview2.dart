// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late WebViewController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("WebView App"),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 _controller.goBack();
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.arrow_forward),
//               onPressed: () {
//                 _controller.goForward();
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: () {
//                 _controller.reload();
//               },
//             ),
//           ],
//         ),
//         body: WebView(
//           initialUrl: 'https://example.com', // Replace with your desired URL
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController) {
//             _controller = webViewController;
//           },
//         ),
//       ),
//     );
//   }
// }
