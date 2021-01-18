import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/utils/get_post_type.dart';
import 'package:reddit_client/widgets/post_content/gif_video_content.dart';
import 'package:reddit_client/widgets/post_content/self_post_content.dart';
import 'package:reddit_client/widgets/post_content/video_content.dart';

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent(this.post);

  @override
  Widget build(BuildContext context) {
    Widget widget = Text('Unimplemented PostType: ${post.postType}');
    if (post.postType == PostType.SelfPost)
      widget = SelfPostContent(text: post.selfText);
    if (post.postType == PostType.Video) widget = VideoContent(post: post);
    if (post.postType == PostType.GifVideo)
      widget = GifVideoContent(post: post);
    return Column(
      children: [
        widget,
      ],
    );
  }
}
