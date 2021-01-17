part of 'feed_bloc.dart';

enum FeedFilter { BEST, HOT, NEW, TOP, RISING }

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedRequested extends FeedEvent {
  final String subreddit;
  final int limit;
  final FeedFilter filter;
  final bool loadMore;

  FeedRequested({
    this.subreddit,
    this.limit = 20,
    this.filter = DEFAULT_FILTER,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [
        subreddit,
        limit,
        filter,
        loadMore,
      ];
}

class FeedLoaded extends FeedEvent {
  final List<Submission> content;

  FeedLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class FeedRefreshRequested extends FeedEvent {
  final String subreddit;
  final int limit;
  final FeedFilter filter;

  FeedRefreshRequested({
    this.subreddit,
    this.limit = 20,
    this.filter = DEFAULT_FILTER,
  });

  @override
  List<Object> get props => [
        subreddit,
        limit,
        filter,
      ];
}
