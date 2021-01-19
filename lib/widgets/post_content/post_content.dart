import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
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
  final Submission post;

  const PostContent(this.post);

  @override
  Widget build(BuildContext context) {
    final postType = getPostType(post);
    if (postType == PostType.SelfPost)
      return SelfPostContent(text: post.selftext);
    if (postType == PostType.Link) return LinkContent(post: post);
    if (postType == PostType.Tweet)
      return TweetContent(url: post.url.toString());
    if (postType == PostType.Image)
      return ImageContent(url: post.url.toString());
    if (postType == PostType.ImgurImage) {
      String imageId = post.url.path.substring(1);
      return ImageContent(url: "https://i.imgur.com/$imageId.jpg");
    }
    if (postType == PostType.Video) return VideoContent(post: post);
    if (postType == PostType.GifVideo) return GifVideoContent(post: post);
    if (postType == PostType.GfycatVideo)
      return GfycatVideoContent(url: post.url);
    if (postType == PostType.YoutubeVideo)
      return YoutubeVideoContent(url: post.url.toString());
    return Text('Unrecognised PostType: $postType');
  }
}
