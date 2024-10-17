import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/admin/screens/dashboard_screen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/customButton.dart';
import 'package:doinikcakri/widgets/customTextfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart'; // For Get.snackbar
import 'package:dotted_border/dotted_border.dart'; // Make sure to add this package

class UploadpostForm extends StatefulWidget {
  const UploadpostForm({Key? key}) : super(key: key);

  @override
  _UploadpostFormState createState() => _UploadpostFormState();
}

class _UploadpostFormState extends State<UploadpostForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Govt';
  late final TextEditingController titleController,
      _priceController,
      podController,
      podnumController,
      joggotaController,
      betonController,
      greadController,
      abedonsuruController,
      abedonsesController,
      locationController,
      applyController,
      detailController;
  List<File> _pickedImages = [];
  List<File> _pickedPDFs = [];

  String _pickedFile = '';
  bool isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  File? _pickedImage2;
  Uint8List webImage2 = Uint8List(8);
  bool _isLoading = false;

  @override
  void initState() {
    titleController = TextEditingController();
    podController = TextEditingController();
    podnumController = TextEditingController();
    joggotaController = TextEditingController();
    betonController = TextEditingController();
    greadController = TextEditingController();
    abedonsuruController = TextEditingController();
    abedonsesController = TextEditingController();
    locationController = TextEditingController();
    applyController = TextEditingController();
    detailController = TextEditingController();
    super.initState();
  }

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        Get.snackbar('Error', 'Please pick an image');
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });
        final storageRef = FirebaseStorage.instance.ref();
        Reference imageRef = storageRef.child('productsImages');
        final filename = _uuid + 'jpg';
        final spaceRef = imageRef.child(filename);

        final uploadTask = await spaceRef.putFile(_pickedImage!);
        final imageUri = await uploadTask.ref.getDownloadURL();

        Reference? pdfRef;
        String? pdfUri;
        if (_pickedFile.isNotEmpty) {
          pdfRef = storageRef.child('productsFiles').child(_uuid + '.pdf');
          final pdfUploadTask = await pdfRef.putFile(File(_pickedFile));
          pdfUri = await pdfUploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': titleController.text,
          'pod_name': podController.text,
          'pod_num': podnumController.text,
          'joggota': joggotaController.text,
          'beton': betonController.text,
          'gread': greadController.text,
          'abedon_suru': abedonsuruController.text,
          'abedon_ses': abedonsesController.text,
          'job_location': locationController.text,
          'apply_link': applyController.text,
          'detail': detailController.text,
          'imageUrl': imageUri,
          'imageUrl2': pdfUri ?? '', // Store PDF URL if available
          'productCategoryName': _catValue,
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        Get.snackbar('Success', 'Product uploaded successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } on FirebaseException catch (error) {
        Get.snackbar('Error', error.message ?? 'An error occurred');
      } catch (error) {
        Get.snackbar('Error', '$error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    setState(() {
      isPiece = false;
      _pickedImage = null;
      webImage = Uint8List(8);
      _pickedImage2 = null;
      webImage2 = Uint8List(8);
      _formKey.currentState?.reset();
    });
  }

  Future<void> _pickImageOrPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: true, // Allow multiple selection
    );

    if (result != null) {
      setState(() {
        result.files.forEach((file) {
          if (file.extension == 'pdf') {
            _pickedPDFs.add(File(file.path!));
          } else {
            _pickedImage2 = File(result.files.single.path!);
          }
        });
      });
    } else {
      print('No files selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.dark;
    final color = Theme.of(context).primaryColor;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = MediaQuery.of(context).size;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            theme ? const Color.fromARGB(255, 255, 255, 255) : Colors.blue,
        title: const Text('Add New Job',
            style: TextStyle(color: Colors.white, fontSize: 19)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _scaffoldColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: _pickedImage == null
                            ? dottedBorder(color: color)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.memory(webImage, fit: BoxFit.fill)
                                    : Image.file(_pickedImage!,
                                        fit: BoxFit.fill),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _pickedImage = null;
                                webImage = Uint8List(8);
                              });
                            },
                            child: const Text('Clear',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 19)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Update image',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 19)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text('চাকরির ধরন:*',
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _categoryDropDown(),
              const SizedBox(height: 20),
              CustomTextField(labelText: 'পদ:', controller: titleController),
              CustomTextField(
                  labelText: 'পদের নাম:', controller: podnumController),
              CustomTextField(
                  labelText: 'পদসংখ্যা:', controller: titleController),
              CustomTextField(
                  labelText: 'যোগ্যতা:', controller: joggotaController),
              CustomTextField(
                  labelText: 'বেতন স্কেল:', controller: betonController),
              CustomTextField(labelText: 'গ্রেড:', controller: greadController),
              CustomTextField(
                labelText: 'Location:',
                controller: locationController,
              ),
              CustomTextField(
                labelText: 'আবেদন শুরুর তারিখ:',
                controller: abedonsuruController,
              ),
              CustomTextField(
                labelText: 'আবেদনের শেষ তারিখ:',
                controller: abedonsesController,
              ),
              CustomTextField(
                labelText: 'আবেদন করার লিংক:',
                controller: applyController,
              ),
              CustomTextField(
                labelText: 'বিস্তারিত:',
                controller: detailController,
                maxLines: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _scaffoldColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: _pickedImages.isEmpty
                            ? dottedBorder(color: color)
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _pickedImages.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: kIsWeb
                                        ? Image.memory(webImage2,
                                            fit: BoxFit.fill)
                                        : Image.file(_pickedImages[index],
                                            fit: BoxFit.fill),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _pickedImages.clear();
                              });
                            },
                            child: const Text('Clear',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 19)),
                          ),
                          TextButton(
                            onPressed: () {
                              _pickImageOrPDF();
                            },
                            child: const Text('Image/Pdf',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 19)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _clearForm,
                      child: const Row(
                        children: [
                          Icon(Icons.clear, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Clear form',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade300),
                    ),
                   _isLoading
                  ? const CircularProgressIndicator()
                  :   CustomButton(onPressed: _uploadForm, title: 'Upload'),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a'); // Dummy file for web
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: const [6.7],
        borderType: BorderType.RRect,
        color: color,
        radius: const Radius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, color: color, size: 50),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text('Choose an image',
                    style: TextStyle(color: Colors.blue, fontSize: 19)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryDropDown() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18),
            value: _catValue,
            onChanged: (value) {
              setState(() {
                _catValue = value!;
              });
              print(_catValue);
            },
            hint: const Text('Select a category'),
            items: const [
              DropdownMenuItem<String>(
                child: Text('Govt'),
                value: 'Govt',
              ),
              DropdownMenuItem<String>(
                child: Text('Private'),
                value: 'Private',
              ),
              DropdownMenuItem<String>(
                child: Text('IT & EEE'),
                value: 'IT & EEE',
              ),
              DropdownMenuItem<String>(
                child: Text('Marketing'),
                value: 'Marketing',
              ),
              DropdownMenuItem<String>(
                child: Text('Bank & NGO'),
                value: 'Bank & NGO',
              ),
              DropdownMenuItem<String>(
                child: Text('Others'),
                value: 'Others',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
