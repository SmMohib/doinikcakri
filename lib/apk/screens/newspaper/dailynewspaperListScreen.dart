import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('News Paper List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('newspapers').snapshots(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no data is available
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No news available.'));
          }

          // Get list of documents
          List<DocumentSnapshot> docs = snapshot.data!.docs;

          // Build a list of news items
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String title = data['name'];
              String imageUrl = data['imageUrl'];
              String websiteUrl = data['websiteUrl'];

              return MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: websiteUrl,
                        name: title,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: primaryColor),
                            right: BorderSide(color: primaryColor),
                            left: BorderSide(color: primaryColor),
                            top: BorderSide(color: primaryColor))),
                    child: Column(
                      children: [
                        Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                        const Divider(),
                        textPoppins(
                            text: title,
                            color: primaryColor,
                            isTile: true,
                            fontSize: 17),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url, name;

  WebViewScreen({required this.url, required this.name});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('${widget.name}'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(value: loadingPercentage / 100.0),
        ],
      ),
    );
  }
}
