// ignore_for_file: unused_element
//flutter build apk --split-per-abi
import 'package:doinikcakri/component/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doinikcakri/apk/bottomNev.dart';
import 'package:doinikcakri/firebase/firebaseApi.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling a background message: ${message.messageId}');
}
//future
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyAu1drJ4qEKGpKMqZ2tn44okZR7cp35ZWw',
  //   appId: '1:251643207614:web:ca65b32bec02fa7fef23ef',
  //   messagingSenderId: '251643207614',
  //   projectId: 'doinikcakri',
  //   authDomain: 'doinikcakri.firebaseapp.com',
  //   storageBucket: 'doinikcakri.appspot.com',
  //   measurementId: 'G-GJ9NSWPZ6Y',));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: Text('An error occured'),
              )),
            );
          }

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'doinik cakri',
            color: whiteColor,
            theme: ThemeData(
             
        colorScheme: const ColorScheme.light(
          primary:secondaryColor,
        ),
        iconTheme: const IconThemeData(color: whiteColor,),
        textTheme: const TextTheme(titleMedium: TextStyle(color: whiteColor)),
        // ignore: prefer_const_constructors
        progressIndicatorTheme: ProgressIndicatorThemeData(circularTrackColor: whiteColor,color: secondaryColor),
        appBarTheme: const AppBarTheme(
        
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          elevation: 0,
          
          iconTheme: IconThemeData(

            color: Colors.white,
          ),
        ),
        useMaterial3: true, // can rem
                //  appBarTheme: AppBarTheme(backgroundColor: primaryColor),
               
               
                scaffoldBackgroundColor: whiteColor,
                buttonTheme: const ButtonThemeData(buttonColor: primaryColor),
            ),
            home: BottomNavBar(),
          );
        });
  }
}
