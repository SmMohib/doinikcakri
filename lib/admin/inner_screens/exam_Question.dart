import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
class ExamQuestionUpload extends StatefulWidget {
  const ExamQuestionUpload({super.key});

  @override
  _ExamQuestionUploadState createState() => _ExamQuestionUploadState();
}

class _ExamQuestionUploadState extends State<ExamQuestionUpload> {
  TextEditingController _titleController = TextEditingController();
  List<File> _selectedFiles = [];
  bool _isPdf = false;
  double _progress = 0.0;
  bool _isUploading = false;

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

  Future<void> _uploadFiles() async {
    if (_titleController.text.isEmpty || _selectedFiles.isEmpty) return;

    setState(() {
      _isUploading = true;
      _progress = 0.0;
    });

    String title = _titleController.text;
    List<String> fileUrls = [];

    for (int i = 0; i < _selectedFiles.length; i++) {
      File file = _selectedFiles[i];
      String fileName = file.path.split('/').last;

      UploadTask task = FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putFile(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress = (i / _selectedFiles.length) + 
                      (snapshot.bytesTransferred / snapshot.totalBytes) / _selectedFiles.length;
        });
      });

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      fileUrls.add(downloadUrl);
    }

    await FirebaseFirestore.instance.collection('questions').add({
      'title': title,
      'fileUrls': fileUrls,
      'isPdf': _isPdf,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Files uploaded successfully!'),
    ));

    setState(() {
      _titleController.clear();
      _selectedFiles.clear();
      _isPdf = false;
      _isUploading = false;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Files'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text('Select Files'),
            ),
            const SizedBox(height: 20),
            _selectedFiles.isEmpty
                ? const Text('No files selected')
                : Text('${_selectedFiles.length} file(s) selected'),
            const SizedBox(height: 20),
            _isUploading
                ? Column(
                    children: [
                      CircularProgressIndicator(
                        value: _progress,
                      ),
                      const SizedBox(height: 10),
                      Text('${(_progress * 100).toStringAsFixed(0)}% uploaded'),
                    ],
                  )
                : Container(),
            const Spacer(),
            ElevatedButton(
              onPressed: _uploadFiles,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
