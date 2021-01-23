import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostInfo extends StatelessWidget {
  final Submission post;

  const PostInfo(this.post);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            Text(
              'by ${post.author} in ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/subreddit',
                  arguments: post.subreddit,
                );
              },
              child: Text(
                'r/${post.subreddit.displayName}',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              ' • ',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              timeago
                  .format(post.createdUtc, locale: 'en_short')
                  .replaceAll(" ", ""),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.arrow_upward,
              color: Colors.grey,
              size: 18,
            ),
            SizedBox(width: 2),
            Text(
              post.upvotes.toString(),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              '  •  ',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
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
