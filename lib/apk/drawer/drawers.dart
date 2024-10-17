import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/apk/drawer/coc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:doinikcakri/admin/screens/dashboard_screen.dart';
import 'package:doinikcakri/admin/services/global_method.dart';
import 'package:doinikcakri/apk/screens/favorite/favorite.dart';
import 'package:doinikcakri/apk/screens/policy_page.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/consts/firebase_consts.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:doinikcakri/widgets/text_widget.dart';

import '../screens/auth/login.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<Product> _favoriteProducts = [];
  List<String> _favoriteProductTitles = [];
  List<Product> products = [];
  bool _isOpen = false;
  String? _email;
  String? _name;
  String? address, _number;
  bool? _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _number = userDoc.get('phoneNumber');
        _email = userDoc.get('email');
        _name = userDoc.get('name');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/kormo-logo.png'),
              ),
            ),
            child: Text(''),
          ),

          _listTiles(
              title: 'Home',
              icon: IconlyLight.home,
              onPressed: () {
                Navigator.pop(context);
              },
              color: textsecondColor),
          _listTiles(
              title: 'Profile',
              icon: IconlyLight.profile,
              onPressed: () {
               Get.to(JobPostEditor());
              },
              color: textsecondColor),
          _listTiles(
              title: 'add',
              icon: IconlyLight.document,
              onPressed: () {
                Get.to(DashboardScreen(),);
              },
              color: textsecondColor),
          _listTiles(
              title: 'Favorite',
              icon: IconlyLight.heart,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavoritesScreen(favoriteProducts: _favoriteProducts),
                  ),
                );
              },
              color: textsecondColor),

          _listTiles(
              title: 'Policy',
              icon: IconlyLight.play,
              onPressed: () {
                Get.to(PolicyPage());
              },
              color: textsecondColor),
          // ListTile(
          //   leading: Icon(Icons.history),
          //   title: Text('Viewed History'),
          //   onTap: () {
          //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => (),));
          //     // Navigate to Settings
          //   },
          // ),
          _listTiles(
            title: user == null ? 'Add New' : 'Add New',
            icon: user == null ? IconlyLight.addUser : IconlyLight.addUser,
            onPressed: () {
              if (user == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  DashboardScreen(),
                ),
              );
            },
            color: textsecondColor,
          ),
          _listTiles(
            title: user == null ? 'Login' : 'Logout',
            icon: user == null ? IconlyLight.login : IconlyLight.logout,
            onPressed: () {
              if (user == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                return;
              }
              GlobalMethods.warningDialog(
                  title: 'Sign out',
                  subtitle: 'Do you wanna sign out?',
                  fct: () async {
                    await authInstance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  context: context);
            },
            color: textsecondColor,
          ),

          //   ListTile(
          //     leading: Icon(Icons.add_a_photo),
          //     title: Text('Post Job'),
          //     onTap: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));

          //    },
          //  ),
        ],
      ),
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        // isTitle: true,
      ),
      leading: Icon(icon),
      onTap: () {
        onPressed();
      },
    );
  }
}
