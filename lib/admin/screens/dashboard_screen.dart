import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/admin/inner_screens/coaching.dart';
import 'package:doinikcakri/admin/inner_screens/cvUpload.dart';
import 'package:doinikcakri/admin/inner_screens/daily_newsPaper.dart';
import 'package:doinikcakri/admin/inner_screens/exam_Question.dart';
import 'package:doinikcakri/admin/inner_screens/noteMaterial.dart';
import 'package:doinikcakri/admin/inner_screens/weekly_jobNews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doinikcakri/admin/inner_screens/add_prod.dart';
import 'package:doinikcakri/admin/screens/loading_manager.dart';
import 'package:doinikcakri/apk/screens/notice.dart';
import 'package:doinikcakri/apk/screens/questionScreen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:doinikcakri/widgets/texts.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    super.key,
    this.model,
  });
  final Product? model;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;

  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      await Get.snackbar(
        '',
        'Product has been deleted',
      );
      //  Fluttertoast.showToast(
      //   msg: "Product has been deleted",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      // );
    } catch (error) {
      Get.snackbar('Error', 'Error: $error');
      // Fluttertoast.showToast(
      //   msg: "Error: $error",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Product>> fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) {
      return Product(
          id: doc['id'],
          title: doc['title'],
          podName: doc['pod_name'],
          podNum: doc['pod_num'],
          joggota: doc['joggota'],
          beton: doc['beton'],
          jobLocation: doc['job_location'],
          applyLink: doc['apply_link'],
          detail: doc['detail'],
          imageUrl: doc['imageUrl'],
          imageUrl2: doc['imageUrl2'],
          productCategoryName: doc['productCategoryName'],
          createdAt: (doc['createdAt']),
          gread: '',
          abedonSuru: '',
          abedonSes: '');
    }).toList();
  }

  Future<void> updateProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update({
      'title': product.title,
      'pod_name': product.podName,
      'pod_num': product.podNum,
      'joggota': product.joggota,
      'beton': product.beton,
      'gread': product.gread,
      'abedon_suru': product.abedonSuru,
      'abedon_ses': product.abedonSes,
      'job_location': product.jobLocation,

      'apply_link': product.applyLink,
      'detail': product.detail,
      'imageUrl': product.imageUrl, 'imageUrl2': product.imageUrl2,

      'productCategoryName': product.productCategoryName,

      'createdAt': product.createdAt, // if you're updating this field
    });
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this product?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteProduct(productId); // Call the delete method
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ///

  final List<String> categories = [
    'Bangla',
    'English',
    'Math',
    'General Knowledge'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.post_add),
                          title: new Text('Reguler Job Post'),
                          onTap: () {
                            Get.to(const UploadpostForm());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.newspaper),
                          title: new Text('Daily Newspaper'),
                          onTap: () {
                            Get.to(NewspaperUploadScreen());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.newspaper),
                          title: new Text('Weekly Job Newspaper'),
                          onTap: () {
                            Get.to(PDFUploadScreen());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.question_answer),
                          title: new Text('Exam Question'),
                          onTap: () {
                            Get.to(ExamQuestionUpload());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.photo_filter),
                          title: new Text('Other Material'),
                          onTap: () {
                            Get.to(CategoryScreen());
                           
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.document_scanner),
                          title: new Text('CV Format'),
                          onTap: () {
                            Get.to(CvUploadScreen());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.list_alt),
                          title: new Text('Coaching List'),
                          onTap: () {
                            Get.to(CoachingScreen());
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.notifications_none),
                          title: new Text('Notice'),
                          onTap: () {
                            Get.to(NoticeUploadScreen());
                          },
                        ),
                      ],
                    ),
                  );
                });
          }),
      body: LoadingManager(
        isLoading: _isLoading,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error fetching products"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No products available"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var product = snapshot.data!.docs[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(product['title']),
                  subtitle: Text(product['pod_name']),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'update') {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => EditProductScreen(model: produc,

                        //     ),
                        //   ),
                        // );
                      } else if (value == 'delete') {
                        _deleteProduct(product.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  ///title text
  Widget titleText({required String text1, required String text2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: text18(
              text: text1, color: textsecondColor, isTile: true, fontSize: 13),
        ),
        text18(
            text: text2.toString(),
            color: textsecondColor,
            isTile: false,
            fontSize: 13)
      ],
    );
  }
}
