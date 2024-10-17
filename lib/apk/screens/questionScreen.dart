import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available.'));
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String title = data['title'];
              List<String> fileUrls = List<String>.from(data['fileUrls']);
              bool isPdf = data['isPdf'];
              String documentId = docs[index].id;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: title,
                        fileUrls: fileUrls,
                        isPdf: isPdf,
                        documentId: documentId,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    isPdf
                        ? const LinearProgressIndicator() // Progress indicator for PDFs
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

///
class PDFViewWidget extends StatelessWidget {
  final String pdfUrl;

  const PDFViewWidget({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    
    return PDF().cachedFromUrl(
      pdfUrl,
      placeholder: (double progress) =>
          Center(child: CircularProgressIndicator(value: progress)),
      errorWidget: (dynamic error) =>
          Center(child: Text(error.toString())),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String title;
  final List<String> fileUrls;
  final bool isPdf;
  final String documentId;

  const DetailScreen({super.key, 
    required this.title,
    required this.fileUrls,
    required this.isPdf,
    required this.documentId,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.isPdf
          ? PDFView(
              filePath: widget.fileUrls.first,
              onPageChanged: (page, total) {
                setState(() {
                  _currentPage = page!;
                  _totalPages = total!;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                pdfViewController.getPageCount().then((count) {
                  setState(() {
                    _totalPages = count!;
                  });
                });
              },
            )
          : ListView(
              children: widget.fileUrls.map((url) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: widget.isPdf
          ? Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Page $_currentPage of $_totalPages'),
                ],
              ),
            )
          : null,
    );
  }
}
