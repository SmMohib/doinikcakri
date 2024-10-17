// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../component/colors.dart';
class CustomListView extends StatelessWidget {
  final int length;
  final List<String> title;
  final Function(int) onTap; // Now takes an index for each route

  CustomListView({
    Key? key,
    required this.length,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(4.0),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide(width: 1, color: primaryColor), // Assuming primaryColor is blue
            ),
            title: Text(title[index]),
            onTap: () {
             onTap(index); // Pass the index to the callback
            },
          ),
        );
      },
    );
  }
}
