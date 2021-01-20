part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchSubredditInProgress extends SearchState {}

class SearchSubredditSuccess extends SearchState {
  final DateTime updatedAt;
  final List<Subreddit> result;

  SearchSubredditSuccess(this.updatedAt, this.result);

  @override
  List<Object> get props => [updatedAt, result];
}

class SearchSubredditFailure extends SearchState {}
