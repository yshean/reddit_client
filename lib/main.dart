import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/app_router.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/repositories/index.dart';
import 'package:reddit_client/repositories/search_repository.dart';
import 'package:reddit_client/search/search_bloc.dart';
import 'package:reddit_client/secrets.dart';
import 'package:reddit_client/simple_bloc_observer.dart';
import 'package:reddit_client/subreddit/subreddit_bloc.dart';
import 'package:uuid/uuid.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FeedRepository feedRepository;
  SearchRepository searchRepository;
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: 'flutter-yshean',
      deviceId: Uuid().v4(),
    ).then((redditClient) {
      setState(() {
        feedRepository = FeedRepository(redditClient);
        searchRepository = SearchRepository(redditClient);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (feedRepository == null) {
      return MaterialApp(
        title: 'Reddit Client',
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FeedBloc(feedRepository)
            ..add(FeedRequested(filter: DEFAULT_FRONT_FILTER)),
        ),
        BlocProvider(
          create: (context) => SubredditBloc(feedRepository),
        ),
        BlocProvider(
          create: (context) => SearchBloc(searchRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Reddit Client',
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
