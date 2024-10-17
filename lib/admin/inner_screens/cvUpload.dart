import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/model/pdf.dart';
import 'package:doinikcakri/widgets/customButton.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// PDF Upload Screen
class CvUploadScreen extends StatefulWidget {
  const CvUploadScreen({super.key});

  @override
  _CvUploadScreenState createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends State<CvUploadScreen> {
  TextEditingController _titleController = TextEditingController();
  bool isLoading = false;
  double progress = 0.0;

  Future<void> uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isLoading = true;
        progress = 0.0;
      });

      String fileName = result.files.single.name;
      String titleName = _titleController.text;
      String filePath = result.files.single.path!;

      try {
        String uuid = const Uuid().v1();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child("cv/$uuid");
        UploadTask uploadTask = storageRef.putFile(File(filePath));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        });

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        PDFDocument pdfDocument = PDFDocument(
          titleName: titleName,
          fileName: fileName,
          url: downloadUrl,
        );

        await FirebaseFirestore.instance
            .collection('cv')
            .add(pdfDocument.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload complete')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
          progress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload CV PDF")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : uploadPDF,
              child: isLoading
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Uploading CV...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : const Text("Upload CV"),
            ),
          ],
        ),
      ),
    );
  }
}
