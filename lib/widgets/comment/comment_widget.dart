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
  Comment _comment;

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
  void initState() {
    super.initState();
    _comment = widget.comment;
  }

  void refreshList() {
    setState(() {
      _comment = _comment;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_collapseChildren)
      return CollapsedComment(
        level: _level,
        commentBorderColor: commentBorderColor,
        comment: _comment,
        expandComment: () {
          setState(() {
            _collapseChildren = false;
          });
        },
      );
    return ExpandedComment(
      level: _level,
      commentBorderColor: commentBorderColor,
      comment: _comment,
      collapseComment: () {
        setState(() {
          _collapseChildren = true;
        });
      },
      refreshList: refreshList,
    );
  }
}

class CollapsedComment extends StatelessWidget {
  final int level;
  final List<Color> commentBorderColor;
  final Comment comment;
  final void Function() expandComment;

  const CollapsedComment({
    Key key,
    this.level,
    this.commentBorderColor,
    this.comment,
    this.expandComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: expandComment,
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              margin: EdgeInsets.only(
                left: level > 0 ? level * 4.0 : 0.0,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 4.0,
                    color: level < commentBorderColor.length
                        ? commentBorderColor[level]
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
                      Row(
                        children: [
                          Icon(Icons.arrow_right),
                          Text(
                            comment.author,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            timeago.format(comment.createdUtc,
                                locale: 'en_short'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 6),
                          if (comment.replies != null)
                            Text(
                              '(${comment.replies.length} ${comment.replies.length == 1 ? 'reply' : 'replies'})',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedComment extends StatelessWidget {
  final int level;
  final List<Color> commentBorderColor;
  final Comment comment;
  final void Function() collapseComment;
  final void Function() refreshList;

  const ExpandedComment({
    Key key,
    this.level,
    this.commentBorderColor,
    this.comment,
    this.collapseComment,
    this.refreshList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            margin: EdgeInsets.only(
              left: level > 0 ? level * 4.0 : 0.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 4.0,
                  color: level < commentBorderColor.length
                      ? commentBorderColor[level]
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
                      onTap: collapseComment,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_drop_down),
                          Text(
                            comment.author,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            timeago.format(comment.createdUtc,
                                locale: 'en_short'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    data: HtmlUnescape().convert(comment.body),
                    onTapLink: (text, link, _) => launch(link),
                    styleSheet: customMarkdownStyleSheet,
                  ),
                ),
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
                      comment.upvotes.toString(),
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
        if (comment.replies != null)
          for (MapEntry c in comment.replies.comments.asMap().entries)
            if (c.value is Comment)
              CommentWidget(
                comment: c.value,
                level: level + 1,
              )
            else if (c.value is MoreComments)
              LoadMoreComments(
                comment: c.value,
                level: level + 1,
                commentBorderColor: commentBorderColor,
                addToCommentList: (newComments) {
                  comment.replies.comments.removeAt(c.key);
                  comment.replies.comments.insertAll(c.key, newComments);
                  refreshList();
                },
              ),
      ],
    );
  }
}

class LoadMoreComments extends StatefulWidget {
  final MoreComments comment;
  final int level;
  final List<Color> commentBorderColor;
  final void Function(List<dynamic>) addToCommentList;

  const LoadMoreComments({
    Key key,
    this.comment,
    this.level,
    this.commentBorderColor,
    this.addToCommentList,
  }) : super(key: key);

  @override
  _LoadMoreCommentsState createState() => _LoadMoreCommentsState();
}

class _LoadMoreCommentsState extends State<LoadMoreComments> {
  bool _isLoading = false;

  void loadComments() {
    setState(() {
      _isLoading = true;
    });
    widget.comment.comments(update: false).then((res) {
      widget.addToCommentList(res);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loadComments,
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              margin: EdgeInsets.only(
                left: widget.level > 0 ? widget.level * 4.0 : 0.0,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 4.0,
                    color: widget.level < widget.commentBorderColor.length
                        ? widget.commentBorderColor[widget.level]
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
                      Row(
                        children: [
                          Icon(Icons.arrow_right),
                          Text(
                            'load more comments (${widget.comment.count} ${widget.comment.count == 1 ? 'reply' : 'replies'})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                          if (_isLoading)
                            Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                              height: 10,
                              width: 10,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
