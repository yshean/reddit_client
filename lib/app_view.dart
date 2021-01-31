import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/app_router.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/post_search/post_search_bloc.dart';
import 'package:reddit_client/profile/profile_bloc.dart';
import 'package:reddit_client/repositories/auth_repository.dart';
import 'package:reddit_client/repositories/index.dart';
import 'package:reddit_client/repositories/search_repository.dart';
import 'package:reddit_client/subreddit/subreddit_bloc.dart';
import 'package:reddit_client/subreddit_search/subreddit_search_bloc.dart';
import 'package:uni_links/uni_links.dart';

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final AppRouter _appRouter = AppRouter();

  StreamSubscription _sub;

  @override
  void initState() {
    _sub = getUriLinksStream().listen((Uri uri) async {
      // Use the uri and warn the user, if it is not correct
      if (uri != null && uri.queryParameters["code"] != null) {
        final authCode = uri.queryParameters["code"];
        await context.read<AuthRepository>().login(authCode);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This does not update redditClient when AuthStatus changes
    final redditClient =
        context.select((AuthRepository repository) => repository.redditClient);
    final feedRepository = FeedRepository(redditClient);
    final searchRepository = SearchRepository(redditClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FeedBloc(feedRepository),
        ),
        BlocProvider(
          create: (context) => SubredditBloc(feedRepository),
        ),
        BlocProvider(
          create: (context) => SubredditSearchBloc(searchRepository),
        ),
        BlocProvider(
          create: (context) => PostSearchBloc(searchRepository),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ProfileBloc(authBloc: context.read<AuthBloc>()),
        )
      ],
      child: MaterialApp(
        title: 'Amber',
        onGenerateRoute: _appRouter.onGenerateRoute,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.amber,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
