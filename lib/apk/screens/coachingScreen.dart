import 'package:doinikcakri/component/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoachingListScreen extends StatefulWidget {
  @override
  _CoachingListScreenState createState() => _CoachingListScreenState();
}

class _CoachingListScreenState extends State<CoachingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching Center'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('coaching_posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No coaching posts found.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              var title = post['title'] ?? 'No Title';
              var description = post['description'] ?? 'No Description';
              var imageUrls = List<String>.from(post['imageUrls'] ?? []);
              var timestamp = post['timestamp']?.toDate() ?? DateTime.now();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                   shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1, color: primaryColor), // Assuming primaryColor is blue
                            ),
                  title: Text(title),
                  subtitle: Text(description),
                  leading: imageUrls.isNotEmpty
                      ? Image.network(
                          imageUrls.first,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  onTap: () {
                    // Navigate to detailed view of the post
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachingDetailScreen(post),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CoachingDetailScreen extends StatelessWidget {
  final DocumentSnapshot post;

  CoachingDetailScreen(this.post);

  @override
  Widget build(BuildContext context) {
    var title = post['title'] ?? 'No Title';
    var description = post['description'] ?? 'No Description';
    var imageUrls = List<String>.from(post['imageUrls'] ?? []);
    var timestamp = post['timestamp']?.toDate() ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(imageUrls[index], fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Posted on: ${timestamp.toLocal()}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(description, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
