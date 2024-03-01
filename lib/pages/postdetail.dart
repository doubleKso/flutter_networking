import 'package:flutter/material.dart';
import 'package:typicodenetworking/models/post.dart';
import 'package:typicodenetworking/pages/editpost.dart';
import 'package:typicodenetworking/services/apiservice.dart';

import '../widgets/showmessage_widget.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  PostDetail(this.post, {super.key});
  @override
  State<PostDetail> createState() => _DetailState();
}

class _DetailState extends State<PostDetail> {
  late Post _post;
  ApiService _apiService = ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              deletePost(_post);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              toEditPost(context, _post);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (_post.title ?? "").toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_post.body ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }

  deletePost(Post post) {
    //sigle responsibility
    _apiService.delete(post.id!).then((result) {
      if (result.status) {
        showMessage(context, "Success", result.message, callBack: () {
          Navigator.pop(context, true);
        });
      } else {
        showMessage(context, "Error", result.message);
      }
    });
  }

  toEditPost(context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditPostPage(post);
        },
      ),
    ).then((editedPost) {
      if (editedPost != null) {
        setState(() {
          _post = editedPost;
        });
      }
    });
  }
}
