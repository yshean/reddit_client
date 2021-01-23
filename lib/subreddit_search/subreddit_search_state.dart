part of 'subreddit_search_bloc.dart';

abstract class SubredditSearchState extends Equatable {
  const SubredditSearchState();

  @override
  List<Object> get props => [];
}

class SearchSubredditInitial extends SubredditSearchState {}

class SearchSubredditInProgress extends SubredditSearchState {}

class SearchSubredditSuccess extends SubredditSearchState {
  final DateTime updatedAt;
  final List<SubredditRef> result;

  SearchSubredditSuccess(this.updatedAt, this.result);

  @override
  List<Object> get props => [updatedAt, result];
}

class SearchSubredditFailure extends SubredditSearchState {}
