import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/utils/custom_markdown_stylesheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final int level;

  const CommentWidget({
    Key key,
    this.comment,
    this.level,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  int get _level => widget.level;
  bool _collapseChildren = false;

  final List<Color> commentBorderColor = [
    Colors.grey,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.blueGrey,
    Colors.pink,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            margin: EdgeInsets.only(
              left: _level > 0 ? _level * 4.0 : 0.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 4.0,
                  color: _level < commentBorderColor.length
                      ? commentBorderColor[_level]
                      : Colors.cyan,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _collapseChildren = !_collapseChildren;
                        });
                      },
                      child: Row(
                        children: [
                          _collapseChildren
                              ? Icon(Icons.arrow_right)
                              : Icon(Icons.arrow_drop_down),
                          Text(
                            widget.comment.author,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            timeago.format(widget.comment.createdUtc,
                                locale: 'en_short'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 6),
                          if (_collapseChildren &&
                              widget.comment.replies != null)
                            Text(
                              '(${widget.comment.replies.length} ${widget.comment.replies.length == 1 ? 'reply' : 'replies'})',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!_collapseChildren)
                      Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ),
                  ],
                ),
                if (!_collapseChildren)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownBody(
                      data: HtmlUnescape().convert(widget.comment.body),
                      onTapLink: (text, link, _) => launch(link),
                      styleSheet: customMarkdownStyleSheet,
                    ),
                  ),
                if (!_collapseChildren)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.comment.upvotes.toString(),
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
                  ),
              ],
            ),
          ),
        ),
        if (widget.comment.replies != null && !_collapseChildren)
          for (dynamic comment in widget.comment.replies.comments)
            if (comment is Comment)
              CommentWidget(
                comment: comment,
                level: _level + 1,
              ),
      ],
    );
  }
}
