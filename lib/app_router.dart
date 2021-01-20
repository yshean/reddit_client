import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/screens/feed_screen.dart';
import 'package:reddit_client/screens/subreddit_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FeedScreen());
      case '/subreddit':
        final SubredditRef subredditRef = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SubredditScreen(subredditRef: subredditRef));
      default:
        return null;
    }
  }
}
