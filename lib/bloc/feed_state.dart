part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedLoadInProgress extends FeedState {}

class FeedLoadSuccess extends FeedState {
  final List<Submission> feeds;

  FeedLoadSuccess(this.feeds);

  @override
  List<Object> get props => [feeds];
}

class FeedLoadFailure extends FeedState {
  final Error error;

  FeedLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
