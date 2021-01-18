import 'package:draw/draw.dart';
import 'package:reddit_client/feed/feed_bloc.dart';

class NotImplemented implements Exception {}

class FeedRepository {
  final Reddit redditClient;

  FeedRepository(this.redditClient);

  Stream<UserContent> getFeed({
    int limit,
    String after,
    FeedFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    if (filter == FeedFilter.BEST) throw NotImplemented();
    if (filter == FeedFilter.HOT) return redditClient.front.hot(params: params);
    if (filter == FeedFilter.NEW)
      return redditClient.front.newest(params: params);
    if (filter == FeedFilter.TOP) throw NotImplemented();
    if (filter == FeedFilter.RISING)
      return redditClient.front.rising(params: params);

    return null;
  }
}
