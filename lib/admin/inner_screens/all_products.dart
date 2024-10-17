import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doinikcakri/admin/screens/dashboard_screen.dart';
import 'package:doinikcakri/widgets/text_widget.dart';

import '../responsive.dart';
class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
     
        title: TextWidget(
          text: 'All Jobs',
          color: Colors.white,
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
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      // key: context.read().getgridscaffoldKey,

      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))    
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      // Header(
                      //   fct: () {
                      //     context.read().controlProductsMenu();
                      //   },
                      //   title: 'All products',
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                     
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
