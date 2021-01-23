import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class SubredditTile extends StatelessWidget {
  final SubredditRef subreddit;

  const SubredditTile({Key key, this.subreddit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('r/${subreddit.displayName}'),
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          '/subreddit',
          arguments: subreddit,
        );
      },
    );
  }
}
