import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/screens/post_details.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final Submission submission;

  const PostCard({Key key, this.submission}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Submission _submission;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
  }

  String get thumbnailSrc =>
      _submission.preview.isEmpty || _submission.thumbnail.host == ''
          ? null
          : _submission.thumbnail.toString();

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
                  _submission.author,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  timeago.format(_submission.createdUtc),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                final updatedSubmission =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PostDetails(_submission),
                ));
                setState(() {
                  _submission = updatedSubmission;
                });
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
                          _submission.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _submission.clicked
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'r/${_submission.subreddit.displayName}',
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
                      _submission.numComments.toString(),
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
                      _submission.upvotes.toString(),
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
