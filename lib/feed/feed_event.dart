part of 'feed_bloc.dart';

enum FeedFilter { BEST, HOT, NEW, TOP, RISING }

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedRequested extends FeedEvent {
  final int limit;
  final FeedFilter filter;
  final bool loadMore;

  FeedRequested({
    this.limit = 10,
    this.loadMore = false,
    this.filter,
  }) : assert(filter != null);

  @override
  List<Object> get props => [
        limit,
        filter,
        loadMore,
      ];
}

class FeedLoaded extends FeedEvent {
  final DateTime updatedAt;
  final List<Submission> content;

  FeedLoaded(this.updatedAt, this.content);

  @override
  List<Object> get props => [updatedAt, content];
}

class FeedRefreshRequested extends FeedEvent {
  final int limit;
  final FeedFilter filter;

  FeedRefreshRequested({
    this.limit = 10,
    this.filter,
  }) : assert(filter != null);

  @override
  List<Object> get props => [
        limit,
        filter,
      ];
}
