part of 'subreddit_search_bloc.dart';

abstract class SubredditSearchEvent extends Equatable {
  const SubredditSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSubredditRequested extends SubredditSearchEvent {
  final String query;

  SearchSubredditRequested(this.query);

  @override
  List<Object> get props => [query];
}

class SearchSubredditLoaded extends SubredditSearchEvent {
  final DateTime updatedAt;
  final List<Subreddit> result;

  SearchSubredditLoaded(this.updatedAt, this.result);

  @override
  List<Object> get props => [updatedAt, result];
}

class SearchSubredditCleared extends SubredditSearchEvent {}
