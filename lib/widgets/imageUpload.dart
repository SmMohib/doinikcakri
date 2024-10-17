import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSelectionPage extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  ImageSelectionPage({required this.onImagesSelected});

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage();
    
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages = pickedImages.map((e) => File(e.path)).toList();
      });

      // Call the callback function with the selected images
      widget.onImagesSelected(_selectedImages);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      widget.onImagesSelected(_selectedImages); // Update the parent
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: _selectedImages.isEmpty
                  ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.file(_selectedImages[index], fit: BoxFit.cover),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _selectedImages.isEmpty
            ? const Text('No images selected', style: TextStyle(fontSize: 16))
            : ElevatedButton(
                onPressed: () {
                  // Handle next action with selected images
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Images selected!')),
                  );
                },
                child: const Text('Proceed with Selected Images'),
              ),
      ],
    );
  }
}
