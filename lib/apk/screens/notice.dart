import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/model/notice_model.dart';
import 'package:doinikcakri/widgets/texts.dart';
import 'package:uuid/uuid.dart';

class NoticeUploadScreen extends StatefulWidget {
  @override
  _NoticeUploadScreenState createState() => _NoticeUploadScreenState();
}

class _NoticeUploadScreenState extends State<NoticeUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> uploadNotice() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String uuid = Uuid().v1();
    Notice notice = Notice(
      title: _titleController.text,
      description: _descriptionController.text,
      id: uuid,
    );

    try {
      await FirebaseFirestore.instance.collection('notices').doc(uuid).set(notice.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notice uploaded successfully')),
      );
      _titleController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Notice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 50,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : uploadNotice,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Upload Notice'),
            ),
          ],
        ),
      ),
    );
  }
}

//////


class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot> fetchNotices() {
    return FirebaseFirestore.instance.collection('notices').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: textPoppins(text: 'Notices', color: textsecondColor, isTile: false, fontSize: 18),
        //title: const Text('Notices'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchNotices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notices found.'));
          } else {
            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Notice notice = Notice.fromMap(docs[index].data() as Map<String, dynamic>, docs[index].id);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(notice.title),
                    subtitle: Text(notice.description),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
