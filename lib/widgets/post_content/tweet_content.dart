import 'package:flutter/material.dart';

class TweetContent extends StatelessWidget {
  final String url;

  const TweetContent({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Text("Tweet"),
    );
  }
}
