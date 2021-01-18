import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/repositories/index.dart';
import 'package:reddit_client/screens/feed_screen.dart';
import 'package:reddit_client/secrets.dart';
import 'package:reddit_client/simple_bloc_observer.dart';
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

  @override
  void initState() {
    Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: 'flutter-yshean',
      deviceId: Uuid().v4(),
    ).then((redditClient) {
      setState(() {
        feedRepository = FeedRepository(redditClient);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Client',
      home: feedRepository == null
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : BlocProvider(
              create: (context) =>
                  FeedBloc(feedRepository)..add(FeedRequested()),
              child: FeedScreen(),
            ),
    );
  }
}
