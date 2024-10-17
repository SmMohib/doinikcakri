import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:flutter/material.dart';
import 'package:doinikcakri/admin/screens/dashboard_screen.dart';
import 'package:doinikcakri/widgets/text_widget.dart';


class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
       
          
        title: TextWidget(
          text: 'User Feedback',
          color: whiteColor,
          textSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      // key: context.read().getgridscaffoldKey,

      body: Container(
        child: Card(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('feedback').snapshots(),
              builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(

                      //length
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(49, 34, 34, 34)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Name: ${snapshot.data!.docs[index]['name']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Text(

                                      //   snapshot.data!.docs[index]['timestamp'].toString(),
                                      //   style: const TextStyle(
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "Gmail: ${snapshot.data!.docs[index]['email']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Colors.black26,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Comment: ${snapshot.data!.docs[index]['comments']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }));
                } else {
                  return Container();
                }
              })),
        ),
      ),
    );
  }
}
