import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/widgets/comment/comment_widget.dart';

class CommentList extends StatelessWidget {
  final Submission post;

  const CommentList({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: post.refreshComments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data.comments.isEmpty)
              return Center(child: Text("No comments"));
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (dynamic topComment in snapshot.data.comments)
                  if (topComment is Comment)
                    CommentWidget(comment: topComment, level: 0)
              ],
            );
          } else {
            if (snapshot.hasError) {
              return Text("Couldn't retrieve comments - ${snapshot.error}");
            }
            return Text(
              "--- No comments ---",
              // style: TextStyle(
              //   color: lightGreyColor,
              // ),
            );
          }
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(
                  //   redditOrange,
                  // ),
                  // backgroundColor: darkGreyColor,
                  ),
            ),
          );
        }
      },
    );
  }
}
