part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRequested extends SearchEvent {
  final String query;

  SearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

class SearchLoaded extends SearchEvent {
  final DateTime updatedAt;
  final List<SubredditRef> result;

  SearchLoaded(this.updatedAt, this.result);

  @override
  List<Object> get props => [updatedAt, result];
}

class SearchCleared extends SearchEvent {}
