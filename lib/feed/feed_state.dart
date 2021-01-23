part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedLoadInProgress extends FeedState {}

class FeedLoadSuccess extends FeedState {
  final DateTime updatedAt;
  final List<Submission> feeds;
  final bool hasReachedMax;

  FeedLoadSuccess(this.updatedAt, this.feeds, this.hasReachedMax);

  @override
  List<Object> get props => [updatedAt, feeds, hasReachedMax];
}

class FeedLoadFailure extends FeedState {
  final Error error;

  FeedLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FeedRefreshInProgress extends FeedState {}
