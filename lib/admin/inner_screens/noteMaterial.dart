import 'package:doinikcakri/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'Bangla',
    'English',
    'Math',
    'General Knowledge',
    'ICT'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              // Navigate to the Upload Screen and pass the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteMaterialUploadScreen(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}




class  NoteMaterialUploadScreen extends StatefulWidget {
  final String category; // The selected category

  NoteMaterialUploadScreen({required this.category});

  @override
  _NoteMaterialUploadScreenState createState() => _NoteMaterialUploadScreenState();
}

class _NoteMaterialUploadScreenState extends State<NoteMaterialUploadScreen> {
  TextEditingController _textController = TextEditingController();
  List<File> _selectedFiles = [];
  bool _isPdf = false;
  bool _isUploading = false;
  double _uploadProgress = 0;

  // Pick files (PDF or Images)
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => File(path!)).toList();
        _isPdf = result.files.first.extension == 'pdf';
      });
    }
  }

  // Upload Text, PDFs, or Images to Firestore
  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty && _textController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    String text = _textController.text;
    List<String> fileUrls = [];

    for (File file in _selectedFiles) {
      String fileName = file.path.split('/').last;
      UploadTask task = FirebaseStorage.instance
          .ref('uploads/${widget.category}/$fileName')
          .putFile(file);

      // Monitor upload progress
      task.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      fileUrls.add(downloadUrl);
    }

    // Save data to Firestore under the selected category
    await FirebaseFirestore.instance.collection('materials').add({
      'category': widget.category,
      'text': text,
      'fileUrls': fileUrls,
      'isPdf': _isPdf,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data uploaded successfully to ${widget.category}!'),
    ));

    setState(() {
      _textController.clear();
      _selectedFiles.clear();
      _isPdf = false;
      _isUploading = false;
      _uploadProgress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Data to ${widget.category}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text input
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text Content (optional)',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // File picker button
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text('Select Files (Image/PDF)'),
            ),
            const SizedBox(height: 20),
            // Show selected files
            _selectedFiles.isEmpty
                ? const Text('No files selected')
                : Text('${_selectedFiles.length} file(s) selected'),
            const SizedBox(height: 20),
            // Upload button with progress bar

               _isUploading
                  ?  Column(
                    children: [
                      CircularProgressIndicator(value: _uploadProgress),
                      const SizedBox(height: 10),
                      Text('${(_uploadProgress * 100).toStringAsFixed(2)}% uploaded'),
                    ],
                  )
                  :CustomButton( onPressed: () {
                        _uploadFiles;
                      }, title: 'Upload'),
                  
          
          ],
        ),
      ),
    );
  }
}
