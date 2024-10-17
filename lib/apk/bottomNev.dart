import 'package:flutter/material.dart';
import 'package:doinikcakri/apk/screens/categories.dart';
import 'package:doinikcakri/apk/screens/searchScreen.dart';
import 'package:doinikcakri/apk/tab/categoryTabScreen.dart';
import 'package:doinikcakri/component/colors.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int current_index = 0;
  final List<Widget> pages = [CategoryTabScreen(), SearchScreen(), const CategoryScreen()];

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current_index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BottomNavigationBar(
            elevation: 0,
              backgroundColor: primaryColor,
              iconSize: 18,
              selectedItemColor: whiteColor,
              unselectedItemColor: const Color.fromARGB(202, 184, 182, 182),
              currentIndex: current_index,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              onTap: OnTapped,
              // ignore: prefer_const_literals_to_create_immutables
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search", tooltip: "Search"),
                const BottomNavigationBarItem(
                    icon: const Icon(Icons.category),
                    label: "Category",
                    tooltip: "Category"),
              ]),
        ),
      ),
    );
  }
}