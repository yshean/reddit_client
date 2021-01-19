import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Submission submission;
  final Widget Function(BuildContext) detailsBuilder;

  String get thumbnailSrc =>
      submission.preview.isEmpty || submission.thumbnail.host == ''
          ? null
          : submission.thumbnail.toString();

  const PostCard({Key key, this.submission, this.detailsBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  submission.author,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  timeago.format(submission.createdUtc),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: detailsBuilder,
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'r/${submission.subreddit.displayName}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  thumbnailSrc == null
                      ? SizedBox.shrink()
                      : Image.network(thumbnailSrc, scale: 1.5),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      submission.numComments.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                      submission.upvotes.toString(),
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
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
