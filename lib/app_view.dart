import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/app_router.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/post_search/post_search_bloc.dart';
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
  FeedRepository feedRepository;
  SearchRepository searchRepository;
  final AppRouter _appRouter = AppRouter();

  StreamSubscription _sub;

  @override
  void initState() {
    _sub = getUriLinksStream().listen((Uri uri) async {
      // Use the uri and warn the user, if it is not correct
      if (uri != null && uri.queryParameters["code"] != null) {
        final authCode = uri.queryParameters["code"];
        print('authCode: $authCode');
        await context.read<AuthRepository>().login(authCode);
        print(await context.read<AuthRepository>().getUser());
        // final redditClient = Reddit.createInstalledFlowInstance(
        //   clientId: clientId,
        //   userAgent: "flutter-yshean",
        //   redirectUri: Uri.parse("amberforreddit://yshean.com"),
        // );
        // await redditClient.auth.authorize(uri.queryParameters["code"]);
        // Redditor redditor = await redditClient.user.me();
        // print(redditor.displayName);
        // final redditClient = context.read<AuthRepository>().redditClient;
        // setState(() {
        //   feedRepository = FeedRepository(redditClient);
        //   searchRepository = SearchRepository(redditClient);
        // });
        // Cannot navigate here
        // Navigator.of(context).pushReplacementNamed("/");
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   Navigator.of(context).pushReplacementNamed("/");
        // });
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
    // Reddit.createUntrustedReadOnlyInstance(
    //   clientId: clientId,
    //   userAgent: 'flutter-yshean',
    //   deviceId: Uuid().v4(),
    // ).then((redditClient) {
    //   setState(() {
    //     feedRepository = FeedRepository(redditClient);
    //     searchRepository = SearchRepository(redditClient);
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (feedRepository == null || searchRepository == null) {
    //   return MaterialApp(
    //     title: 'Amber',
    //     home: Scaffold(
    //       body: Center(
    //         child: Container(
    //           width: 300,
    //           height: 300,
    //           child: Image.asset('assets/icons/amber_splash.png'),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    final redditClient =
        context.select((AuthRepository repository) => repository.redditClient);
    final feedRepository = FeedRepository(redditClient);
    final searchRepository = SearchRepository(redditClient);

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
          create: (context) => SubredditSearchBloc(searchRepository),
        ),
        BlocProvider(
          create: (context) => PostSearchBloc(searchRepository),
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
      primaryColor: Colors.amber,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
