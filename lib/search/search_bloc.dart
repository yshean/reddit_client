import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_client/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;

  SearchBloc(this._searchRepository) : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchRequested) {
      yield SearchSubredditInProgress();
      _searchRepository
          .searchSubreddit(event.query)
          .then((result) => add(SearchLoaded(DateTime.now(), result)));
    } else if (event is SearchLoaded) {
      yield SearchSubredditSuccess(event.updatedAt, event.result);
    } else if (event is SearchCleared) {
      yield SearchInitial();
    }
  }
}
