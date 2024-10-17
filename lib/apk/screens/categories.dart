import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/apk/screens/note_Material.dart';
import 'package:doinikcakri/apk/screens/newspaper/dailynewspaperListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doinikcakri/apk/screens/ageCalculator.dart';
import 'package:doinikcakri/apk/screens/coachingScreen.dart';
import 'package:doinikcakri/apk/screens/cv.dart';
import 'package:doinikcakri/apk/screens/notice.dart';
import 'package:doinikcakri/apk/screens/newspaper/weeklyNews.dart';
import 'package:doinikcakri/apk/screens/questionScreen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});


  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Stream<QuerySnapshot> fetchPDFs() {
    return FirebaseFirestore.instance.collection('pdfs').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: const Text('Others Categories'),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomCategory(
                    img: 'assets/jobs.png',
                    text: '    Weekly Job News    ',
                    onPressed: () {
                      Get.to(const PDFListScreen());
                    }),
                CustomCategory(
                    img: 'assets/newspaper.png',
                    text: '  Daily News Paper    ',
                    onPressed: () {
                      Get.to(NewsListScreen());
                    }),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
          CustomCategory(
                    img: 'assets/age.png',
                    text: '      Age Calculator        ',
                    onPressed: () {
                      Get.to(AgeCalculatorScreen());
                    }),      
                CustomCategory(
                    img: 'assets/resume.png',
                    text: '          CV Format           ',
                    onPressed: () {
                      Get.to(const CVListScreen());
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomCategory(
                    img: 'assets/r.png',
                    text: '      Exam Material       ',
                    onPressed: () {
                      Get.to( NoteMaterialView());
                    }),
                
                    CustomCategory(
                    img: 'assets/coaching.png',
                    text: ' Best Job Coaching ',
                    onPressed: () {
                      Get.to( CoachingListScreen());
                    }),
               
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomCategory(
                    img: 'assets/question.png',
                    text: '    Exam Questions      ',
                    onPressed: () {
                      Get.to(ViewScreen());
                    }),
                 CustomCategory(
                    img: 'assets/notice.png',
                    text: '        Exam Notice         ',
                    onPressed: () {
                      Get.to(const NoticeListScreen());
                    }),
              ],
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class CustomCategory extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  String img;

  CustomCategory(
      {super.key, required this.text, required this.onPressed, required this.img});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: secondaryColor),
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 21, 95, 190), Color.fromARGB(255, 22, 28, 99)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        img,
                        height: 90,
                        width: 90,
                      ),
                    ),
                   
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textPoppins(
                            text: text,
                            //text: 'সাপ্তাহিক চাকরির পত্রিকা',
                            color: textColor,
                            isTile: true,
                            fontSize: 13) //
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
