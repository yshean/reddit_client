import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/repositories/feed_repository.dart';

part 'subreddit_event.dart';
part 'subreddit_state.dart';

class SubredditBloc extends Bloc<SubredditEvent, SubredditState> {
  final FeedRepository _feedRepository;
  StreamSubscription _feedSubscription;
  List<Submission> _subredditContents = [];

  SubredditBloc(this._feedRepository) : super(SubredditFeedLoadInProgress());

  @override
  Stream<SubredditState> mapEventToState(
    SubredditEvent event,
  ) async* {
    if (event is SubredditFeedRequested) {
      yield* _mapFeedRequestedToState(event);
    } else if (event is SubredditFeedLoaded) {
      yield SubredditFeedLoadSuccess(event.updatedAt, event.content);
    } else if (event is SubredditFeedRefreshRequested) {
      yield* _mapFeedRefreshRequestedToState(event);
    }
  }

  Stream<SubredditState> _mapFeedRequestedToState(
      SubredditFeedRequested event) async* {
    _feedSubscription?.cancel();
    if (event.loadMore == false) {
      _subredditContents.clear();
      yield SubredditFeedLoadInProgress();
    }
    _feedSubscription = _feedRepository
        .getSubredditFeed(
      subredditName: event.subreddit,
      filter: event.filter,
      limit: event.limit,
      after: event.loadMore ? _subredditContents.last.fullname : null,
    )
        .listen(
      (content) {
        _subredditContents.add(content);
      },
      onDone: () {
        add(SubredditFeedLoaded(DateTime.now(), _subredditContents));
      },
    );
  }

  Stream<SubredditState> _mapFeedRefreshRequestedToState(
      SubredditFeedRefreshRequested event) async* {
    _feedSubscription?.cancel();
    _subredditContents.clear();
    yield SubredditFeedRefreshInProgress();

    _feedSubscription = _feedRepository
        .getSubredditFeed(
      subredditName: event.subreddit,
      filter: event.filter,
      limit: event.limit,
    )
        .listen(
      (content) {
        _subredditContents.add(content);
      },
      onDone: () {
        add(SubredditFeedLoaded(DateTime.now(), _subredditContents));
      },
    );
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
