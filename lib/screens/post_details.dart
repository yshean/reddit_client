import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/widgets/post_content/post_content.dart';
import 'package:reddit_client/widgets/post_info.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // Post info
          PostInfo(post),
          PostContent(post),
          // Comments filter
          Row(
            children: [
              Text('BEST'),
            ],
          ),
          // Comments listview
          Column(
            children: [
              Text('Comments'),
            ],
          ),
        ],
      ),
    );
  }
}
