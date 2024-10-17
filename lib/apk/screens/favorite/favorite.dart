import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:doinikcakri/apk/tab/detailScreen.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  final List<Product> favoriteProducts;

  FavoritesScreen({required this.favoriteProducts});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Remove a product from the favorites list
  void _removeFromFavorites(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites');
    if (favoriteList != null) {
      favoriteList.removeWhere(
          (item) => Product.fromJson(json.decode(item)).title == product.title);
      prefs.setStringList('favorites', favoriteList);

      setState(() {
        widget.favoriteProducts
            .removeWhere((item) => item.title == product.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jobs'),
       
      ),
      body: widget.favoriteProducts.isEmpty
          ? const Center(child: Text('No favorites added yet.'))
          : ListView.builder(
              itemCount: widget.favoriteProducts.length,
              itemBuilder: (context, index) {
                Product product = widget.favoriteProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      side:  BorderSide(width: 1, color: primaryColor),
                     // borderRadius: BorderRadius.circular(20),
                    ),
                    // tileColor: primaryColor,
                    title: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(product: product),
                                ),
                              );
                            },
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailScreen(product: product));
                                //        Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => DetailScreen(product: product),
                                //   ),
                                // );
                              },
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                product.title,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -15,
                          right: -30,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: const Icon(
                                IconlyLight.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _removeFromFavorites(product);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                   
                    leading: ClipRRect(
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
                    subtitle: InkWell(
                      onTap: () {
                        Get.to(DetailScreen(product: product));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            'Position: ${product.podName}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: textsecondColor,
                            ),
                          ),
                          titleText(
                              text1: 'Last Date: ', text2: product.abedonSes),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: text18(
                                    text: 'Salary: ',
                                    color: textsecondColor,
                                    isTile: true,
                                    fontSize: 13),
                              ),
                              text18(
                                  text: '${product.beton} /=',
                                  color: textsecondColor,
                                  isTile: false,
                                  fontSize: 13),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
