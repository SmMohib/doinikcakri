import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/custom_ListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart'; 
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


class NoteMaterialView extends StatelessWidget {
  final List<String> categories = [
    'Bangla',
    'English',
    'Math',
    'General Knowledge',
    'ICT',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        title: const Text('Exam Materials'),
      ),

      body: CustomListView(
        length: categories.length,
        title: categories, // Passing the entire categories list
        onTap: (index) {
          // Navigate to CategoryDataListScreen with the specific category
          Get.to(CategoryDataListScreen(category: categories[index]));
        },
      ),
    );
  }
}


class CategoryDataListScreen extends StatelessWidget {
  final String category;

  CategoryDataListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        title: Text('$category'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('materials')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available in this category.'));
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String title = data['text'] ?? 'No Title';
              List<String> fileUrls = List<String>.from(data['fileUrls']);
              bool isPdf = data['isPdf'];
              String documentId = docs[index].id;
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                   shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: primaryColor),
                        
                      ),
                  title: Text(title),
                  onTap: () {
                    // Navigate to the Data View Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DataViewScreen(
                          title: title,
                          fileUrls: fileUrls,
                          isPdf: isPdf,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class DataViewScreen extends StatefulWidget {
  final String title;
  final List<String> fileUrls;
  final bool isPdf;

  DataViewScreen({
    required this.title,
    required this.fileUrls,
    required this.isPdf,
  });

  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  double _currentZoom = 1.0; // Initialize zoom level

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
        ],
      ),
      body: widget.isPdf
          ? PDFViewWidget(pdfUrl: widget.fileUrls.first, currentZoom: _currentZoom)
          : ListView.builder(
              itemCount: widget.fileUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to full screen image viewer with zoom
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageZoomScreen(
                            imageUrl: widget.fileUrls[index],
                            currentZoom: _currentZoom,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.fileUrls[index],
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Zoom in function
  void _zoomIn() {
    setState(() {
      _currentZoom += 0.2; // Increase zoom level
    });
  }

  // Zoom out function
  void _zoomOut() {
    setState(() {
      if (_currentZoom > 1.0) {
        _currentZoom -= 0.2; // Decrease zoom level, but not less than 1.0
      }
    });
  }
}

class PDFViewWidget extends StatelessWidget {
  final String pdfUrl;
  final double currentZoom;

  PDFViewWidget({required this.pdfUrl, required this.currentZoom});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PDFView(
        filePath: pdfUrl,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        onRender: (pages) {
          // Handle render event
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }
}




class ImageZoomScreen extends StatelessWidget {
  final String imageUrl;
  final double currentZoom;

  ImageZoomScreen({required this.imageUrl, required this.currentZoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Viewer"),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * currentZoom, // Set zoom level
          maxScale: PhotoViewComputedScale.covered * 3.0, // Adjust as needed
        ),
      ),
    );
  }
}
