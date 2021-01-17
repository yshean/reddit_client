import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/bloc/feed_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/repositories/index.dart';
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
              appBar: AppBar(title: Text('Reddit')),
              body: Text('Failed to create repository'),
            )
          : BlocProvider(
              create: (context) =>
                  FeedBloc(feedRepository)..add(FeedRequested()),
              child: FeedScreen(),
            ),
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit'),
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FeedLoadSuccess) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index == state.feeds.length - NEXT_PAGE_THRESHOLD) {
                  context.read<FeedBloc>().add(FeedRequested(loadMore: true));
                }
                if (index < state.feeds.length) {
                  return ListTile(
                    title: Text(state.feeds[index].title),
                  );
                }
                return null;
              },
            );
          }
          if (state is FeedLoadFailure) {
            return Center(
              child: Text('Oops'),
            );
          }
          return null;
        },
      ),
    );
  }
}
