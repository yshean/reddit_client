import 'package:draw/draw.dart';
import 'package:meta/meta.dart';
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

    if (filter == FeedFilter.BEST)
      return redditClient.front.best(params: params);
    if (filter == FeedFilter.HOT) return redditClient.front.hot(params: params);
    if (filter == FeedFilter.NEW)
      return redditClient.front.newest(params: params);
    if (filter == FeedFilter.TOP) return redditClient.front.top(params: params);
    if (filter == FeedFilter.RISING)
      return redditClient.front.rising(params: params);

    return null;
  }

  Stream<UserContent> getSubredditFeed({
    @required String subredditName,
    int limit,
    String after,
    FeedFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    assert(filter != FeedFilter.BEST);

    if (filter == FeedFilter.HOT)
      return redditClient.subreddit(subredditName).hot(params: params);
    if (filter == FeedFilter.NEW)
      return redditClient.subreddit(subredditName).newest(params: params);
    if (filter == FeedFilter.TOP)
      return redditClient.subreddit(subredditName).top(params: params);
    if (filter == FeedFilter.RISING)
      return redditClient.subreddit(subredditName).rising(params: params);

    return null;
  }
}
