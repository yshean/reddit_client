import 'package:bloc/bloc.dart';
import 'package:reddit_client/feed/feed_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent $event');
    if (event is FeedRequested)
      print('FeedRequested subreddit: ${event.subreddit}');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    print('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(cubit, error, stackTrace);
  }
}
