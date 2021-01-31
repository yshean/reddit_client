import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/utils/convert_whitespace_char.dart';
import 'package:reddit_client/utils/custom_markdown_stylesheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final int level;

  const CommentWidget({
    Key key,
    @required this.comment,
    @required this.level,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  int get _level => widget.level;
  bool _collapseChildren = false;
  Comment _comment;

  final List<Color> commentBorderColor = [
    Colors.white,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.grey,
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
                            timeago
                                .format(comment.createdUtc, locale: 'en_short')
                                .replaceAll(" ", ""),
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

class ExpandedComment extends StatefulWidget {
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
  _ExpandedCommentState createState() => _ExpandedCommentState();
}

class _ExpandedCommentState extends State<ExpandedComment> {
  bool _isUpvoted = false;
  bool _isDownvoted = false;

  @override
  void initState() {
    super.initState();
    // Get the state of the comment
    // Hive.openBox('cache').then((box) {
    //   if (box.isNotEmpty) {
    //     _upvotedIds = List<String>.from(jsonDecode(box.get('upvoted') ?? '[]'));
    //     if (_upvotedIds.contains(_submission.id)) _isUpvoted = true;

    //     _downvotedIds =
    //         List<String>.from(jsonDecode(box.get('downvoted') ?? '[]'));
    //     if (_downvotedIds.contains(_submission.id)) _isDownvoted = true;

    //     _savedIds = List<String>.from(jsonDecode(box.get('saved') ?? '[]'));
    //     if (_savedIds.contains(_submission.id)) _isSaved = true;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
          return Slidable.builder(
            enabled: authState is Authenticated &&
                !(widget.comment.body == '[removed]'),
            key: Key(widget.comment.id),
            actionPane: SlidableDrawerActionPane(),
            secondaryActionDelegate: SlideActionBuilderDelegate(
                actionCount: 2,
                builder: (context, index, animation, renderingMode) {
                  if (index == 0)
                    return IconSlideAction(
                      caption: _isUpvoted ? 'Upvoted' : 'Upvote',
                      color: Colors.green,
                      icon: _isUpvoted
                          ? Icons.check
                          : Icons.arrow_upward_outlined,
                      onTap: () async {
                        setState(() {
                          _isUpvoted = !_isUpvoted;
                          _isDownvoted = false;
                        });
                        if (!_isUpvoted) {
                          await widget.comment.clearVote();
                        } else {
                          await widget.comment.upvote();
                        }

                        // Also refetch upvoted/downvoted ids
                        // context.read<ProfileBloc>().add(ProfileContentRequested(
                        //       section: ProfileSection.UPVOTED,
                        //       filter: DEFAULT_PROFILE_FILTER,
                        //     ));
                        // context.read<ProfileBloc>().add(ProfileContentRequested(
                        //       section: ProfileSection.DOWNVOTED,
                        //       filter: DEFAULT_PROFILE_FILTER,
                        //     ));
                        Slidable.of(context).close();
                      },
                      closeOnTap: false,
                    );
                  if (index == 1)
                    return IconSlideAction(
                      caption: _isDownvoted ? 'Downvoted' : 'Downvote',
                      color: Colors.red,
                      icon: _isDownvoted
                          ? Icons.check
                          : Icons.arrow_downward_outlined,
                      onTap: () async {
                        setState(() {
                          _isDownvoted = !_isDownvoted;
                          _isUpvoted = false;
                        });
                        if (!_isDownvoted) {
                          await widget.comment.clearVote();
                        } else {
                          await widget.comment.downvote();
                        }
                        // Also refetch upvoted & downvoted ids
                        // context.read<ProfileBloc>().add(ProfileContentRequested(
                        //       section: ProfileSection.UPVOTED,
                        //       filter: DEFAULT_PROFILE_FILTER,
                        //     ));
                        // context.read<ProfileBloc>().add(ProfileContentRequested(
                        //       section: ProfileSection.DOWNVOTED,
                        //       filter: DEFAULT_PROFILE_FILTER,
                        //     ));
                        Slidable.of(context).close();
                      },
                      closeOnTap: false,
                    );
                  return null;
                }),
            child: GestureDetector(
              onTap: widget.collapseComment,
              child: Card(
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
                              Icon(Icons.arrow_drop_down),
                              Text(
                                widget.comment.author,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                timeago
                                    .format(widget.comment.createdUtc,
                                        locale: 'en_short')
                                    .replaceAll(" ", ""),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(width: 6),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.comment.upvotes.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MarkdownBody(
                          data: convertWhiteSpaceChar(
                              HtmlUnescape().convert(widget.comment.body)),
                          onTapLink: (text, link, _) =>
                              launch(link, forceWebView: true),
                          styleSheet: customMarkdownStyleSheet,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (widget.comment.replies != null)
          for (MapEntry c in widget.comment.replies.comments.asMap().entries)
            if (c.value is Comment)
              CommentWidget(
                comment: c.value,
                level: widget.level + 1,
              )
            else if (c.value is MoreComments)
              LoadMoreComments(
                comment: c.value,
                level: widget.level + 1,
                commentBorderColor: widget.commentBorderColor,
                addToCommentList: (newComments) {
                  widget.comment.replies.comments.removeAt(c.key);
                  widget.comment.replies.comments.insertAll(c.key, newComments);
                  widget.refreshList();
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
                            widget.comment.count == 0
                                ? 'Continue comment thread →'
                                : 'load more comments (${widget.comment.count} ${widget.comment.count == 1 ? 'reply' : 'replies'})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
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
