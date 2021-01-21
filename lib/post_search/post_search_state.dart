part of 'post_search_bloc.dart';

abstract class PostSearchState extends Equatable {
  const PostSearchState();

  @override
  List<Object> get props => [];
}

class SearchPostInitial extends PostSearchState {}

class SearchPostInProgress extends PostSearchState {}

class SearchPostSuccess extends PostSearchState {
  final DateTime updatedAt;
  final List<Submission> result;
  final bool hasReachedMax;

  SearchPostSuccess({
    this.updatedAt,
    this.result,
    this.hasReachedMax,
  });

  @override
  List<Object> get props => [updatedAt, result, hasReachedMax];
}

class SearchPostFailure extends PostSearchState {}
