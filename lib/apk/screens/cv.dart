import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doinikcakri/widgets/custom_ListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// CV List Screen
class CVListScreen extends StatelessWidget {
  const CVListScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot> fetchPDFs() {
    return FirebaseFirestore.instance.collection('cv').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: textPoppins(
            text: 'CV Format', color: textColor, isTile: false, fontSize: 18),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchPDFs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No PDF files found.'));
          } else {
            List<DocumentSnapshot> docs = snapshot.data!.docs;

            // Extract title and file URLs from the documents
            List<String> titles = docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return data['titleName'] as String; // Extract title names
            }).toList();

            // Extract file URLs
            List<String> fileUrls = docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return data['url'] as String; // Extract URLs
            }).toList();

            return CustomListView(
              length: titles.length, 
              title: titles,
              onTap: (index) {
                String fileUrl = fileUrls[index]; 
                String fileName = docs[index]['fileName'];
                Get.to(CVViewerScreen(
                  pdfUrl: fileUrl, 
                  fileName: fileName,
                ));
              },
            );
          }
        },
      ),
    );
  }
}


// PDF Viewer Screen
class CVViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;

  const CVViewerScreen({super.key, required this.pdfUrl, required this.fileName});

  @override
  _CVViewerScreenState createState() => _CVViewerScreenState();
}

class _CVViewerScreenState extends State<CVViewerScreen> {
  String? localFilePath;
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/${widget.fileName}";
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
                  onViewCreated: (PDFViewController pdfViewController) {},
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      currentPage = page!;
                    });
                  },
                )
              : Center(
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
                            strokeWidth: 8,
                            strokeAlign: 5,
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
