import 'package:doinikcakri/widgets/customButton.dart';
import 'package:doinikcakri/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewspaperUploadScreen extends StatefulWidget {
  @override
  _NewspaperUploadScreenState createState() => _NewspaperUploadScreenState();
}

class _NewspaperUploadScreenState extends State<NewspaperUploadScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _uploadNewspaper() async {
    String name = _nameController.text;
    String imageUrl = _imageUrlController.text;
    String websiteUrl = _websiteUrlController.text;

    if (name.isEmpty || imageUrl.isEmpty || websiteUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    // Upload the newspaper data to Firestore
    await FirebaseFirestore.instance.collection('newspapers').add({
      'name': name,
      'imageUrl': imageUrl,
      'websiteUrl': websiteUrl,
      'uploadedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Newspaper uploaded successfully!')),
    );

    // Clear the fields
    _nameController.clear();
    _imageUrlController.clear();
    _websiteUrlController.clear();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Newspaper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(labelText: "Name", controller: _nameController),
            CustomTextField(labelText: "News Image Url", controller: _imageUrlController),
            CustomTextField(labelText: "Website Url", controller: _websiteUrlController),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    onPressed: () {
                      _uploadNewspaper(); // Corrected function call
                    },
                    title: 'Upload',
                  ),
          ],
        ),
      ),
    );
  }
}
