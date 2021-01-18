import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostInfo extends StatelessWidget {
  final Post post;

  const PostInfo(this.post);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'by ${post.author}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '${post.commentCount} comments',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Text(
              timeago.format(post.postedAt),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Text(
          'r/${post.subreddit}',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.arrow_upward,
              color: Colors.grey,
              size: 18,
            ),
            SizedBox(width: 4),
            Text(
              post.upvotes.toString(),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_downward,
              color: Colors.grey,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              '${(post.upvoteRatio * 100).round()}% upvoted',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
