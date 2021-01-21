import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_client/repositories/search_repository.dart';

part 'subreddit_search_event.dart';
part 'subreddit_search_state.dart';

class SubredditSearchBloc
    extends Bloc<SubredditSearchEvent, SubredditSearchState> {
  final SearchRepository _searchRepository;

  SubredditSearchBloc(this._searchRepository) : super(SearchSubredditInitial());

  // Uncomment below for debouncing
  // @override
  // Stream<Transition<SearchEvent, SearchState>> transformEvents(
  //     Stream<SearchEvent> events, transitionFn) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 200)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<SubredditSearchState> mapEventToState(
    SubredditSearchEvent event,
  ) async* {
    if (event is SearchSubredditRequested) {
      // Uncomment below for showing loading indicator
      // yield SearchSubredditInProgress();
      final List<SubredditRef> refs =
          await _searchRepository.searchSubreddit(event.query);
      if (refs.isEmpty) {
        add(SearchSubredditLoaded(DateTime.now(), []));
      } else {
        final List<Subreddit> populated = await Future.wait(refs
            .sublist(0, refs.length < 5 ? refs.length : 5)
            .map((ref) => ref.populate()));
        add(SearchSubredditLoaded(DateTime.now(), populated));
      }
    } else if (event is SearchSubredditLoaded) {
      yield SearchSubredditSuccess(event.updatedAt, event.result);
    } else if (event is SearchSubredditCleared) {
      yield SearchSubredditInitial();
    }
  }
}
