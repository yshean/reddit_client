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

  FeedLoadSuccess(this.updatedAt, this.feeds);

  @override
  List<Object> get props => [updatedAt, feeds];
}

class FeedLoadFailure extends FeedState {
  final Error error;

  FeedLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FeedRefreshInProgress extends FeedState {}
