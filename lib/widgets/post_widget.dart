import 'package:flutter/material.dart';
import 'package:typicodenetworking/models/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget(this.post, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            (widget.post.title ?? "").toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.post.body ?? "",
            maxLines: 2,
          ),
        ]),
      ),
    );
  }
}
