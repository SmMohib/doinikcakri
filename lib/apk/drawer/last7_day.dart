// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doinikcakri/apk/tab/detailScreen.dart';
// import 'package:doinikcakri/component/colors.dart';
// import 'package:doinikcakri/model/jobpost_model.dart';
// import 'package:doinikcakri/widgets/texts.dart';

// class JobListingScreen extends StatefulWidget {
//   @override
//   _JobListingScreenState createState() => _JobListingScreenState();
// }

// class _JobListingScreenState extends State<JobListingScreen> {
//   Future<List<Product>> _fetchJobPostings() async {
//     DateTime now = DateTime.now();
//     DateTime sevenDaysFromNow = now.add(Duration(days: 7));

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('job_postings')
//         .where('abedon_ses', isGreaterThanOrEqualTo: now)
//         .where('abedon_ses', isLessThanOrEqualTo: sevenDaysFromNow)
//         .get();

//     return snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: textRoboro(text: 'Kormo Barta', isTile: true, fontSize: 20, color: secondaryColor),
//       ),
//       body: FutureBuilder<List<JobPosting>>(
//         future: _fetchJobPostings(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No job postings found.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 JobPosting jobPosting = snapshot.data![index];
//                 return Column(
//                   children: [
//                     ListTile(
//                       leading: Image.network(jobPosting.imageUrl),
//                       title: Text(jobPosting.title),
//                       subtitle: Text(jobPosting.description, maxLines: 2),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DetailScreen(jobPosting: jobPosting),
//                           ),
//                         );
//                       },
//                     ),
//                     const Divider()
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
