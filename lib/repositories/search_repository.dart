import 'package:draw/draw.dart';

class SearchRepository {
  final Reddit redditClient;

  SearchRepository(this.redditClient);

  Future<List<SubredditRef>> searchSubreddit(String query) =>
      redditClient.subreddits.searchByName(query);

  Stream<UserContent> searchPost({String query, int limit, String after}) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditClient.subreddit("all").search(query, params: params);
  }
}
