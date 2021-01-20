import 'package:draw/draw.dart';

class SearchRepository {
  final Reddit redditClient;

  SearchRepository(this.redditClient);

  Future<List<SubredditRef>> searchSubreddit(String query) =>
      redditClient.subreddits.searchByName(query);
}
