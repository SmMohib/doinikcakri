import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String podName;
  final String podNum;
  final String joggota;
  final String beton;
  final String gread;
  final String abedonSuru;
  final String abedonSes;
  final String jobLocation;
  final String applyLink;
  final String detail;
  final String imageUrl;  final String imageUrl2;
  final String productCategoryName;

  final Timestamp? createdAt;

  Product({
    required this.id,
    required this.title,
    required this.podName,
    required this.podNum,
    required this.joggota,
    required this.beton,
    required this.gread,
    required this.abedonSuru,
    required this.abedonSes,
    required this.jobLocation,
    required this.applyLink,
    required this.detail,
    required this.imageUrl,
    required this.imageUrl2,
    required this.productCategoryName,
    this.createdAt,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc['id'],
      title: doc['title'],
      podName: doc['pod_name'],
      podNum: doc['pod_num'],
      joggota: doc['joggota'],
      beton: doc['beton'],
      gread: doc['gread'],
      abedonSuru: doc['abedon_suru'],
      abedonSes: doc['abedon_ses'],
      jobLocation: doc['job_location'],
      applyLink: doc['apply_link'],
      detail: doc['detail'],
      imageUrl: doc['imageUrl'],
      imageUrl2: doc['imageUrl2'],
      productCategoryName: doc['productCategoryName'],
      createdAt: doc['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pod_name': podName,
      'pod_num': podNum,
      'joggota': joggota,
      'beton': beton,
      'gread': gread,
      'abedon_suru': abedonSuru,
      'abedon_ses': abedonSes,
      'job_location': jobLocation,
      'apply_link': applyLink,
      'detail': detail,
      'imageUrl': imageUrl, 'imageUrl2': imageUrl2,
      'productCategoryName': productCategoryName,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      podName: map['pod_name'],
      podNum: map['pod_num'],
      joggota: map['joggota'],
      beton: map['beton'],
      gread: map['gread'],
      abedonSuru: map['abedon_suru'],
      abedonSes: map['abedon_ses'],
      jobLocation: map['job_location'],
      applyLink: map['apply_link'],
      detail: map['detail'],
      imageUrl: map['imageUrl'],
      imageUrl2: map["imageUrl2"],
      productCategoryName: map['productCategoryName'],
      createdAt: map['createdAt'],
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      podName: json['pod_name'],
      podNum: json['pod_num'],
      joggota: json['joggota'],
      beton: json['beton'],
      gread: json['gread'],
      abedonSuru: json['abedon_suru'],
      abedonSes: json['abedon_ses'],
      jobLocation: json['job_location'],
imageUrl2: json["imageUrl2"],
      applyLink: json['apply_link'],
      detail: json['detail'],
      imageUrl: json['imageUrl'],
      productCategoryName: json['productCategoryName'],

      //createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pod_name': podName,
      'pod_num': podNum,
      'joggota': joggota,
      'beton': beton,
      'gread': gread,
      'abedon_suru': abedonSuru,
      'abedon_ses': abedonSes,
      'job_location': jobLocation,
      'apply_link': applyLink,
      'detail': detail,
      'imageUrl': imageUrl,'imageUrl2': imageUrl2,
      
      'productCategoryName': productCategoryName,
    };
  }
}
