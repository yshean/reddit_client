import 'package:draw/draw.dart';

class FeedRepository {
  final Reddit redditClient;

  FeedRepository(this.redditClient);

  Stream<UserContent> getHotFeed({int limit, String after}) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;
    return redditClient.front.hot(params: params);
  }
}
