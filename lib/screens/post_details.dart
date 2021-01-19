import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/widgets/comment/comment_list.dart';
import 'package:reddit_client/widgets/post_content/post_content.dart';
import 'package:reddit_client/widgets/post_info.dart';

class PostDetails extends StatefulWidget {
  final Submission post;

  const PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Submission _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () {
          return widget.post.refresh().then((post) {
            (post.first as Submission).refreshComments();
            setState(() {
              _post = post.first;
            });
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    PostContent(_post),
                    SizedBox(height: 8.0),
                    PostInfo(_post),
                    SizedBox(height: 4.0),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'COMMENTS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CommentList(post: _post),
            ],
          ),
        ),
      ),
    );
  }
}
