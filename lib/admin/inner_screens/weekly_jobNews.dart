import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/model/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive_io.dart';
import 'dart:typed_data'; // For Uint8List

class PDFUploadScreen extends StatefulWidget {
  @override
  _PDFUploadScreenState createState() => _PDFUploadScreenState();
}

class _PDFUploadScreenState extends State<PDFUploadScreen> {
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

      // Compress PDF to ZIP
      File pdfFile = File(filePath);
      final compressedData = compressFile(pdfFile);

      try {
        String uuid = Uuid().v1();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child("pdfs/$uuid.zip");

        // Convert the compressed data (List<int>) to Uint8List
        Uint8List compressedDataUint8List = Uint8List.fromList(compressedData);

        UploadTask uploadTask = storageRef.putData(compressedDataUint8List);

        // Update progress bar as the file uploads
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        });

        // Wait for the upload to complete
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        PDFDocument pdfDocument = PDFDocument(
          titleName: titleName,
          fileName: fileName,
          url: downloadUrl,
        );

        // Save file information to Firestore
        await FirebaseFirestore.instance
            .collection('pdfs')
            .add(pdfDocument.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload complete')),
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

  // Function to compress the PDF to ZIP
  List<int> compressFile(File file) {
    final archive = Archive();
    final pdfBytes = file.readAsBytesSync();
    final archiveFile = ArchiveFile(file.path.split('/').last, pdfBytes.length, pdfBytes);
    archive.addFile(archiveFile);

    return ZipEncoder().encode(archive)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload PDF")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Post Title"),
            ),
            SizedBox(height: 16),
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
                          const Text(
                            'Loading...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Text("Upload PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
