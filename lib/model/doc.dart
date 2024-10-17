import 'dart:io';

class JobPost {
  String title;
  String content; // Use a string or JSON to hold the formatted text
  List<File> images;

  JobPost({required this.title, required this.content, required this.images});
}
