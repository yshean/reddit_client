import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/profile/profile_bloc.dart';
import 'package:reddit_client/screens/post_details.dart';
import 'package:reddit_client/utils/convert_whitespace_char.dart';
import 'package:reddit_client/widgets/profile_section_switcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final Submission submission;
  final SlidableController slidableController;

  const PostCard({
    Key key,
    @required this.submission,
    @required this.slidableController,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Submission _submission;
  bool _isUpvoted;
  bool _isDownvoted;
  bool _isSaved;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
    _isUpvoted = _submission.data['likes'] == true;
    _isDownvoted = _submission.data['likes'] == false;
    _isSaved = _submission.saved;
  }

  String get thumbnailSrc =>
      _submission.preview.isEmpty || _submission.thumbnail.host == ''
          ? null
          : _submission.thumbnail.toString();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
      return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileContentLoadSuccess &&
              (profileState.section == ProfileSection.UPVOTED ||
                  profileState.section == ProfileSection.DOWNVOTED ||
                  profileState.section == ProfileSection.SAVED)) {
            setState(() {
              _isUpvoted = _submission.data['likes'] == true;
              _isDownvoted = _submission.data['likes'] == false;
              _isSaved = _submission.saved;
            });
          }
        },
        child: Slidable.builder(
          enabled: authState is Authenticated,
          key: Key(_submission.id),
          controller: widget.slidableController,
          actionPane: SlidableDrawerActionPane(),
          // Also check the state of each action
          secondaryActionDelegate: SlideActionBuilderDelegate(
              actionCount: 4,
              builder: (context, index, animation, renderingMode) {
                if (index == 0)
                  return IconSlideAction(
                    caption: _isUpvoted ? 'Upvoted' : 'Upvote',
                    color: Colors.green,
                    icon:
                        _isUpvoted ? Icons.check : Icons.arrow_upward_outlined,
                    onTap: () async {
                      setState(() {
                        _isUpvoted = !_isUpvoted;
                        _isDownvoted = false;
                      });
                      if (!_isUpvoted) {
                        await _submission.clearVote();
                      } else {
                        await _submission.upvote();
                      }
                      _submission.refresh();
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
                        await _submission.clearVote();
                      } else {
                        await _submission.downvote();
                      }
                      _submission.refresh();
                      Slidable.of(context).close();
                    },
                    closeOnTap: false,
                  );
                if (index == 2)
                  return IconSlideAction(
                    caption: _isSaved ? 'Saved' : 'Save',
                    color: Colors.amberAccent,
                    icon: _isSaved ? Icons.check : Icons.star_border,
                    onTap: () async {
                      setState(() {
                        _isSaved = !_isSaved;
                      });
                      if (!_isSaved) {
                        await _submission.unsave();
                      } else {
                        await _submission.save();
                      }
                      _submission.refresh();
                      Slidable.of(context).close();
                    },
                    closeOnTap: false,
                  );
                if (index == 3)
                  return IconSlideAction(
                    caption: 'Share',
                    color: Color(0xFF014A60),
                    icon: Icons.share_outlined,
                  );
                return null;
              }),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PostDetails(_submission),
              ));
            },
            child: Card(
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
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      convertWhiteSpaceChar(HtmlUnescape()
                                          .convert(_submission.title)),
                                      maxLines: 5,
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
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    SizedBox(
                                      width: 8,
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
                                          _submission.score.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
