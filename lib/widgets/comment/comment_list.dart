import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:reddit_client/widgets/comment/comment_widget.dart';

class CommentList extends StatelessWidget {
  final Post post;

  const CommentList({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (post.getComments() == null) {
      return FutureBuilder(
        future: post.refreshComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (dynamic topComment in snapshot.data.comments)
                    if (topComment is Comment)
                      CommentWidget(comment: topComment)
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
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(
                  //   redditOrange,
                  // ),
                  // backgroundColor: darkGreyColor,
                  ),
            );
          }
        },
      );
    } else if (post.getComments().comments.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (dynamic topComment in post.getComments().comments)
            if (topComment is Comment) CommentWidget(comment: topComment)
        ],
      );
    } else {
      return Text(
        "--- No comments ---",
        // style: TextStyle(
        //   color: lightGreyColor,
        // ),
      );
    }
  }
}
