import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doinikcakri/apk/webview/webViews.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/jobpost_model.dart';
import 'package:doinikcakri/widgets/texts.dart';
//import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:photo_view/photo_view.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  DetailScreen({required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Helper method to check if the URL is a PDF
  bool isPDF(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.product.title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the first image
              InkWell(
                onLongPress: () {
                  // _downloadAndSaveImage(widget.product.imageUrl);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FancyShimmerImage(
                    imageUrl: widget.product.imageUrl.toString(),
                    height: MediaQuery.sizeOf(context).height * 0.22,
                    width: MediaQuery.sizeOf(context).width * 1.22,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Divider(),
              Text(
                'পদের নাম: ${widget.product.podName}',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: textsecondColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                textAlign: TextAlign.justify,
                'যোগ্যতা: ${widget.product.joggota}',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: textsecondColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              titleText(
                  text1: 'পদসংখ্যা',
                  color: textsecondColor,
                  text2: widget.product.podNum),
              titleText(
                  text1: 'বেতন স্কেল',
                  color: textsecondColor,
                  text2: '${widget.product.beton}/='),
              titleText(
                  text1: 'গ্রেড',
                  color: textsecondColor,
                  text2: widget.product.gread),
              titleText(
                  text1: 'চাকরির স্থান',
                  color: textsecondColor,
                  text2: widget.product.jobLocation),
              titleText(
                  text1: 'চাকরির ধরন',
                  color: textsecondColor,
                  text2: widget.product.productCategoryName),
              titleText(
                  text1: 'আবেদন শুরুর তারিখ',
                  color: secondaryColor,
                  text2: widget.product.abedonSuru),
              titleText(
                  text1: 'আবেদনের শেষ তারিখ',
                  color: Colors.red,
                  text2: widget.product.abedonSes),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    'আবেদন লিংক:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: textsecondColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: InkWell(
                      onTap: () {
                        Get.to(WebViewApp(webmodel: widget.product));
                      },
                      child: Text(
                        textAlign: TextAlign.start,
                        '${widget.product.applyLink}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: textsecondColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: MaterialButton(
                      height: 22,
                      color: primaryColor,
                      onPressed: () async {
                        final String textToCopy = '${widget.product.applyLink}';
                        if (textToCopy.isNotEmpty) {
                          try {
                            await Clipboard.setData(
                                ClipboardData(text: textToCopy));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Failed to copy to clipboard.')),
                            );
                          }
                        }
                      },
                      child: Text('Copy',style: TextStyle(color: whiteColor),),
                    ),
                  )
                ],
              ),
              const Divider(),
              titleText2(
                text1: 'বিস্তারিত:',
                text2: widget.product.detail,
                color: textsecondColor,
              ),
              // Display either an image or PDF
              const SizedBox(height: 20),
              widget.product.imageUrl2.isEmpty
                  ? const SizedBox()
                  : isPDF(widget.product.imageUrl2)
                      ? SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: PDFView(
                            filePath: widget.product.imageUrl2,
                            autoSpacing: false,
                            enableSwipe: true,
                            pageSnap: true,
                            swipeHorizontal: false,
                            nightMode: false,
                          )
                          // child: PDF().cachedFromUrl(
                          //   widget.product.imageUrl2,
                          //   placeholder: (double progress) =>
                          //       Center(child: CircularProgressIndicator(value: progress)),
                          //   errorWidget: (dynamic error) =>
                          //       Center(child: Text(error.toString())),
                          // ),
                          )
                      : SizedBox(
                          height: 200,
                          child: Center(
                            child: PhotoView(
                              imageProvider:
                                  NetworkImage(widget.product.imageUrl2),
                              backgroundDecoration:
                                  const BoxDecoration(color: Colors.white),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  /// Title text widget
  Widget titleText(
      {required String text1, required String text2, required Color color}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: textPoppins(
            text: "$text1: ",
            color: color,
            isTile: false,
            fontSize: 16,
          ),
        ),
        textPoppins(
          text: "$text2",
          color: color,
          isTile: false,
          fontSize: 16,
        ),
      ],
    );
  }

  /// Title text2 widget
  Widget titleText2(
      {required String text1, required String text2, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textPoppins(
          text: "$text1 ",
          color: color,
          isTile: true,
          fontSize: 17,
        ),
        const Divider(),
        textPoppins(
          text: "$text2",
          color: color,
          isTile: false,
          fontSize: 17,
        ),
      ],
    );
  }
}
