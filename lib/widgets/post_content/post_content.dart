import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/utils/get_post_type.dart';
import 'package:reddit_client/widgets/post_content/gfycat_video_content.dart';
import 'package:reddit_client/widgets/post_content/link_content.dart';
import 'package:reddit_client/widgets/post_content/tweet_content.dart';
import 'package:reddit_client/widgets/post_content/youtube_video_content.dart';

import 'gif_video_content.dart';
import 'image_content.dart';
import 'self_post_content.dart';
import 'video_content.dart';

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent(this.post);

  @override
  Widget build(BuildContext context) {
    if (post.postType == PostType.SelfPost)
      return SelfPostContent(text: post.selfText);
    if (post.postType == PostType.Link) return LinkContent(post: post);
    if (post.postType == PostType.Tweet)
      return TweetContent(url: post.url.toString());
    if (post.postType == PostType.Image)
      return ImageContent(url: post.url.toString());
    if (post.postType == PostType.ImgurImage) {
      String imageId = post.url.path.substring(1);
      return ImageContent(url: "https://i.imgur.com/$imageId.jpg");
    }
    if (post.postType == PostType.Video) return VideoContent(post: post);
    if (post.postType == PostType.GifVideo) return GifVideoContent(post: post);
    if (post.postType == PostType.GfycatVideo)
      return GfycatVideoContent(url: post.url);
    if (post.postType == PostType.YoutubeVideo)
      return YoutubeVideoContent(url: post.url.toString());
    return Text('Unimplemented PostType: ${post.postType}');
  }
}
