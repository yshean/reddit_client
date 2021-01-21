import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubredditTile extends StatelessWidget {
  final Subreddit subreddit;

  const SubredditTile({Key key, this.subreddit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('r/${subreddit.displayName}'),
      subtitle: Text(
          'Community • ${NumberFormat().format(subreddit.data['subscribers'])} members'),
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          '/subreddit',
          arguments: subreddit,
        );
      },
    );
  }
}
