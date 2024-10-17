import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:doinikcakri/apk/tab/detailScreen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/jobpost_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  void _searchProducts(String query) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    setState(() {
      _searchResults = snapshot.docs
          .map((doc) => Product.fromDocument(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          children: [
          
            TextField(
  cursorColor: whiteColor, // Cursor color set to white
  controller: _searchController,
  decoration: const InputDecoration(
    iconColor: whiteColor, // Icon color
    fillColor: whiteColor, // Background fill color
    suffixIcon: Icon(
      IconlyLight.search, 
      size: 20, 
      color: whiteColor, // Suffix icon color
    ),
    hintText: 'Search your job...',
    hintStyle: TextStyle(color: whiteColor), // Hint text color
    border: InputBorder.none, // No border when none
  ),
  style: const TextStyle(color: whiteColor), // Text input color
  onChanged: _searchProducts, // On change search function
),

          ],
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyLight.search,size: 40,),
              SizedBox(height: 10,),
             Icon(
      IconlyLight.search, 
      size: 50, 
      color: primaryColor, // Suffix icon color
    ), SizedBox(height: 10,),
    
              Text('No job found.'),
            ],
          ))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Product product = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                     shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: primaryColor),
                      
                    ),
                    title: Text(maxLines: 1,style: const TextStyle(fontSize:18),product.title),
                    subtitle: Column(
                     
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(maxLines: 1,'Position: ${product.podName}'),
                        Text('Position: ${product.abedonSes}'),
                      ],
                    ),
                    leading: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}