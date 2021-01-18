import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/utils/get_post_type.dart';
import 'package:reddit_client/widgets/post_content/self_post_content.dart';

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent(this.post);

  @override
  Widget build(BuildContext context) {
    if (post.postType == PostType.SelfPost)
      return SelfPostContent(text: post.selfText);
    return Text('Unimplemented PostType: ${post.postType}');
  }
}
