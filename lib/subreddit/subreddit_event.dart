part of 'subreddit_bloc.dart';

abstract class SubredditEvent extends Equatable {
  const SubredditEvent();

  @override
  List<Object> get props => [];
}

class SubredditFeedRequested extends SubredditEvent {
  final String subreddit;
  final int limit;
  final FeedFilter filter;
  final bool loadMore;

  SubredditFeedRequested({
    this.subreddit,
    this.limit = 20,
    this.loadMore = false,
    this.filter,
  }) : assert(subreddit != null && filter != null);

  @override
  List<Object> get props => [
        subreddit,
        limit,
        filter,
        loadMore,
      ];
}

class SubredditFeedLoaded extends SubredditEvent {
  final DateTime updatedAt;
  final List<Submission> content;

  SubredditFeedLoaded(this.updatedAt, this.content);

  @override
  List<Object> get props => [updatedAt, content];
}

class SubredditFeedRefreshRequested extends SubredditEvent {
  final String subreddit;
  final int limit;
  final FeedFilter filter;

  SubredditFeedRefreshRequested({
    this.subreddit,
    this.limit = 20,
    this.filter,
  }) : assert(filter != null);

  @override
  List<Object> get props => [
        subreddit,
        limit,
        filter,
      ];
}
