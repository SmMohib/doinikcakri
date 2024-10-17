import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JobPostEditor extends StatefulWidget {
  @override
  _JobPostEditorState createState() => _JobPostEditorState();
}

class _JobPostEditorState extends State<JobPostEditor> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final ImagePicker _picker = ImagePicker();
  List<File> _pickedImages = [];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImages.add(File(pickedFile.path));
        // Here you can also insert image data into the Quill controller if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Post Editor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillToolbar.simple(controller: _controller),
          Expanded(
            child: quill.QuillEditor(
              controller: _controller,
             
              scrollController: ScrollController(),
              focusNode: FocusNode(),
             
             
            ),
          ),
          // Show picked images (Optional)
          if (_pickedImages.isNotEmpty) ...[
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pickedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      _pickedImages[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
          ElevatedButton(
            onPressed: () {
              // Here you can save the data from _controller to your backend
              print(_controller.document.toPlainText());
            },
            child: const Text("Submit Job Post"),
          ),
        ],
      ),
    );
  }
}



