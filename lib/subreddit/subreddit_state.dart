part of 'subreddit_bloc.dart';

abstract class SubredditState extends Equatable {
  const SubredditState();

  @override
  List<Object> get props => [];
}

class SubredditFeedLoadInProgress extends SubredditState {}

class SubredditFeedLoadSuccess extends SubredditState {
  final DateTime updatedAt;
  final List<Submission> feeds;

  SubredditFeedLoadSuccess(this.updatedAt, this.feeds);

  @override
  List<Object> get props => [updatedAt, feeds];
}

class SubredditFeedLoadFailure extends SubredditState {
  final Error error;

  SubredditFeedLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SubredditFeedRefreshInProgress extends SubredditState {}
