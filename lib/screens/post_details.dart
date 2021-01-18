import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/widgets/comment/comment_list.dart';
import 'package:reddit_client/widgets/post_content/post_content.dart';
import 'package:reddit_client/widgets/post_info.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              PostContent(post),
              SizedBox(height: 8.0),
              PostInfo(post),
              SizedBox(height: 4.0),
              Divider(),
              CommentList(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
