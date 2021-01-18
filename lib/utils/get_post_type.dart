import 'package:draw/draw.dart';

enum PostType {
  SelfPost,
  Link,
  Image,
  Video,
  GifVideo,
  YoutubeVideo,
  Tweet,
  GfycatVideo,
  ImgurImage,
}

PostType getPostTypeFromString(String postTypeAsString) {
  for (PostType element in PostType.values) {
    if (element.toString() == postTypeAsString) {
      return element;
    }
  }
  return null;
}

PostType getPostType(Submission post) {
  if (post.isSelf) return PostType.SelfPost;
  if (RegExp(r"\.(gif|jpe?g|bmp|png)$").hasMatch(post.url.toString()))
    return PostType.Image;
  if (RegExp(
          r"(?:youtube\.com\/\S*(?:(?:\/e(?:mbed))?\/|watch\?(?:\S*?&?v\=))|youtu\.be\/)([a-zA-Z0-9_-]{6,11})")
      .hasMatch(post.url.toString())) return PostType.YoutubeVideo;
  if (["v.redd.it", "i.redd.it", "i.imgur.com"].contains(post.domain) ||
      post.url.toString().contains('.gifv')) return PostType.GifVideo;
  if (post.isVideo) return PostType.Video;
  // if (_post.domain == "twitter.com") return PostType.Tweet;
  // Handle gfycat outside of VideoProvider as it returns 403 links
  if (post.domain == "gfycat.com") return PostType.GfycatVideo;
  if (post.domain == "imgur.com") return PostType.ImgurImage;

  return PostType.Link;
}
