part of 'post_search_bloc.dart';

abstract class PostSearchEvent extends Equatable {
  const PostSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPostRequested extends PostSearchEvent {
  final String query;
  final int limit;
  final bool loadMore;

  SearchPostRequested({
    @required this.query,
    this.limit = 10,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [query];
}

class SearchPostLoaded extends PostSearchEvent {
  final DateTime updatedAt;
  final List<Submission> result;
  final bool hasReachedMax;

  SearchPostLoaded(this.updatedAt, this.result, this.hasReachedMax);

  @override
  List<Object> get props => [updatedAt, result, hasReachedMax];
}

class SearchPostCleared extends PostSearchEvent {}
