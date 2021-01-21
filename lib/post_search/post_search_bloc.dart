import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_client/repositories/search_repository.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  final SearchRepository _searchRepository;
  StreamSubscription _feedSubscription;
  List<Submission> _result = [];

  PostSearchBloc(this._searchRepository) : super(SearchPostInitial());

  @override
  Stream<PostSearchState> mapEventToState(
    PostSearchEvent event,
  ) async* {
    if (event is SearchPostRequested) {
      yield* _mapSearchPostRequestedToState(event);
    } else if (event is SearchPostLoaded) {
      yield SearchPostSuccess(
        updatedAt: event.updatedAt,
        result: event.result,
        hasReachedMax: event.hasReachedMax,
      );
    }
  }

  Stream<PostSearchState> _mapSearchPostRequestedToState(
      SearchPostRequested event) async* {
    _feedSubscription?.cancel();
    if (event.loadMore == false) {
      _result.clear();
      yield SearchPostInProgress();
    }
    int _newResultLength = 0;
    _feedSubscription = _searchRepository
        .searchPost(
      query: event.query,
      limit: event.limit,
      after:
          event.loadMore && _result.isNotEmpty ? _result.last.fullname : null,
    )
        .listen((res) {
      _result.add(res);
      _newResultLength++;
    }, onDone: () {
      add(SearchPostLoaded(
        DateTime.now(),
        _result,
        _newResultLength < event.limit,
      ));
      _newResultLength = 0;
    });
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
