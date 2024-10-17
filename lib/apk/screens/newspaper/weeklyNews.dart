import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:path_provider/path_provider.dart';

class PDFListScreen extends StatelessWidget {
  const PDFListScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot> fetchPDFs() {
    return FirebaseFirestore.instance.collection('pdfs').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: textPoppins(text: "Weekly Job Newspaper", color: whiteColor, isTile: false, fontSize: 18),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchPDFs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No PDF files found.'));
          } else {
            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var data = docs[index].data() as Map<String, dynamic>;
                String titleName = data['titleName'];
                String fileName = data['fileName'];
                String fileUrl = data['url'];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: primaryColor),
                      
                    ),
                    title:  textPoppins(text: titleName, color: primaryColor, isTile: false, fontSize: 18),
                    subtitle: Text(
                      fileName,style: const TextStyle(color: textsecondColor),
                      maxLines: 1,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerScreen(
                              pdfUrl: fileUrl, fileName: fileName),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
/////



class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;

  const PDFViewerScreen({super.key, required this.pdfUrl, required this.fileName});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localFilePath;
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkAndDownloadPDF();
  }

  Future<void> _checkAndDownloadPDF() async {
    Dio dio = Dio();
    try {
      // Get the local document directory
      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/${widget.fileName}";

      // Check if the file already exists locally
      if (File(filePath).existsSync()) {
        setState(() {
          localFilePath = filePath;
          isReady = true;
        });
      } else {
        // If the file doesn't exist, download it
        await dio.download(
          widget.pdfUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                progress = (received / total) * 100;
              });
            }
          },
        );

        setState(() {
          localFilePath = filePath;
          isReady = true;
        });
      }
    } catch (e) {
      print("Error while downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Stack(
        children: [
          // PDF View when the file is downloaded and ready
          localFilePath != null
              ? PDFView(
                  filePath: localFilePath!,
                  autoSpacing: false,
                  enableSwipe: true,
                  pageSnap: true,
                  swipeHorizontal: false,
                  nightMode: false,
                  onRender: (pages) {
                    setState(() {
                      totalPages = pages!;
                    });
                  },
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      currentPage = page!;
                    });
                  },
                )
              : Center(
                  // Show loading progress when the file is downloading
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue,
                          ),
                          Text(
                            '${progress.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Loading...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
          if (isReady)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black54,
                child: Text(
                  "${currentPage + 1} / $totalPages",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
