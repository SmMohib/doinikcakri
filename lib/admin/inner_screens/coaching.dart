// ignore_for_file: prefer_final_fields

import 'package:doinikcakri/widgets/customButton.dart';
import 'package:doinikcakri/widgets/customTextfield.dart';
import 'package:doinikcakri/widgets/imageUpload.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


// class CoachingScreen extends StatefulWidget {
//   @override
//   _CoachingScreenState createState() => _CoachingScreenState();
// }

// class _CoachingScreenState extends State<CoachingScreen> {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//   File? _selectedImage;
//   String _imageUrl = '';
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _uploadData() async {
//     if (_titleController.text.isEmpty ||
//         _descriptionController.text.isEmpty ||
//         _selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please fill all fields and select an image.')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Upload Image to Firebase Storage
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('coaching_images/${DateTime.now().millisecondsSinceEpoch}');
//       UploadTask uploadTask = storageRef.putFile(_selectedImage!);

//       await uploadTask.whenComplete(() async {
//         _imageUrl = await storageRef.getDownloadURL();
//       });

//       // Upload data to Firestore
//       await FirebaseFirestore.instance.collection('coaching_posts').add({
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'imageUrl': _imageUrl,
//         'timestamp': DateTime.now(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Coaching post uploaded successfully!')),
//       );

//       _clearForm();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to upload: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _clearForm() {
//     _titleController.clear();
//     _descriptionController.clear();
//     setState(() {
//       _selectedImage = null;
//       _imageUrl = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Coaching Post'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: _selectedImage == null
//                     ? Container(
//                         height: 200,
//                         width: double.infinity,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.add_a_photo,
//                             size: 50, color: Colors.grey),
//                       )
//                     : Image.file(
//                         _selectedImage!,
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//               CustomTextField(
//                 labelText: "Title",
//                 controller: _titleController,
//               ),
//               CustomTextField(
//                 labelText: "Description",
//                 controller: _descriptionController,
//                 maxLines: 5,
//               ),
//               SizedBox(child: ImageUploadPage()),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : CustomButton(
//                       title: 'Upload Coaching Post',
//                       onPressed: _uploadData,
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

class CoachingScreen extends StatefulWidget {
  @override
  _CoachingScreenState createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  
  bool _isLoading = false;
  List<File> _selectedImages = [];

  Future<void> _uploadData(List<File> selectedImages) async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select images.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imageUrls = [];

      // Upload each image to Firebase Storage and collect the download URLs
      for (File image in selectedImages) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'coaching_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');
        UploadTask uploadTask = storageRef.putFile(image);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageRef.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }

      // Upload post data along with the image URLs to Firestore
      await FirebaseFirestore.instance.collection('coaching_posts').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrls': imageUrls, // Store all image URLs as a list
        'timestamp': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coaching post uploaded successfully!')),
      );

      _clearForm(); // Clear the form after successful upload
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImages.clear(); // Clear all selected images
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Coaching Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pass a callback to get images from ImageSelectionPage
              ImageSelectionPage(
                onImagesSelected: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
              ),
              CustomTextField(
                labelText: "Title",
                controller: _titleController,
              ),
              CustomTextField(
                labelText: "Description",
                controller: _descriptionController,
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      onPressed: () {
                        _uploadData(_selectedImages); // Correct function call
                      },
                      title: 'Upload Coaching Post',
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
