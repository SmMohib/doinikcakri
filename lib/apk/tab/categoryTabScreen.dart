import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:doinikcakri/apk/drawer/drawers.dart';
import 'package:doinikcakri/apk/screens/favorite/favorite.dart';
import 'package:doinikcakri/apk/tab/detailScreen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CategoryTabScreen extends StatefulWidget {
  @override
  _CategoryTabScreenState createState() => _CategoryTabScreenState();
}

class _CategoryTabScreenState extends State<CategoryTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Product> _favoriteProducts = [];

  final List<String> _categories = [
    'For You',
    'Govt',
    'Private',
    'Bank & NGO',
    'IT & EEE',
    'Marketing',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadFavorites(); // Load favorites when the screen initializes
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load favorite products from shared_preferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites');
    if (favoriteList != null) {
      setState(() {
        _favoriteProducts = favoriteList
            .map((item) => Product.fromJson(json.decode(item)))
            .toList();
      });
    }
  }

  // Save favorite products to shared_preferences
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = _favoriteProducts
        .map((product) => json.encode(product.toJson()))
        .toList();
    prefs.setStringList('favorites', favoriteList);
  }

  // Toggle the favorite status of a product
  void _toggleFavorite(Product product) {
    setState(() {
      if (_isFavorite(product)) {
        _favoriteProducts.removeWhere((item) => item.title == product.title);
      } else {
        _favoriteProducts.add(product);
      }
      _saveFavorites(); // Save favorites whenever they are updated
    });
  }

  // Check if a product is a favorite
  bool _isFavorite(Product product) {
    return _favoriteProducts.any((item) => item.title == product.title);
  }

  Widget _buildCategoryTab(String category) {
    Query query = FirebaseFirestore.instance.collection('products');
    if (category != 'For You') {
      query = query.where('productCategoryName', isEqualTo: category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Any Job Found.'));
        } else {
          List<Product> products = snapshot.data!.docs
              .map((doc) => Product.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: primaryColor),
                    //borderRadius: BorderRadius.circular(20),
                  ),
                  // tileColor: primaryColor,
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(product: product),
                        ),
                      );
                    },
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      product.title,
                      style: const TextStyle(
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl.toString(),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => FancyShimmerImage(
                              imageUrl: product.imageUrl.toString(),
                              height: 70,
                              width: 70,
                              boxFit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -27,
                        left: -20,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: textPoppins(
                                    text:
                                        product.productCategoryName.toString(),
                                    color: secondaryColor,
                                    isTile: false,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                            
                            bottom: -20,
                            right: -30,
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: IconButton(
                                                   icon: Icon(
                                                     _isFavorite(product)
                                                         ? IconlyLight.heart
                                                         : IconlyLight.heart,
                                                     color: _isFavorite(product) ? Colors.red : null,
                                                   ),
                                                   onPressed: () {
                                                     _toggleFavorite(product);
                                                   },
                                                 ),
                             ),
                           ),
                    ],
                  ),
                  subtitle: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(product: product),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(maxLines: 1, 'Position: ${product.podName}'),
                            Text(maxLines: 1, 'Salary: ${product.beton}'),
                            Text(maxLines: 1, 'Last Date: ${product.abedonSes}'),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                 
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
       
        title: const Text('দৈনিক চাকরি'),
        elevation: 0,
        bottom: TabBar(
          labelColor: whiteColor,
          indicatorColor: whiteColor,
          dividerColor: primaryColor,
          unselectedLabelColor: const Color.fromARGB(220, 248, 248, 248),
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
        actions: [
          IconButton(
            icon:  const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favoriteProducts: _favoriteProducts),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _categories.map((category) => _buildCategoryTab(category)).toList(),
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
