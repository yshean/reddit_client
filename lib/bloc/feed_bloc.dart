import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_client/constants.dart';

import '../repositories/index.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;
  StreamSubscription _feedSubscription;
  List<Submission> _contents = [];

  FeedBloc(this._feedRepository) : super(FeedLoadInProgress());

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedRequested) {
      yield* _mapFeedRequestedToState(event);
    } else if (event is FeedLoaded) {
      yield FeedLoadSuccess(event.updatedAt, event.content);
    } else if (event is FeedRefreshRequested) {
      yield* _mapFeedRefreshRequestedToState(event);
    }
  }

  Stream<FeedState> _mapFeedRequestedToState(FeedRequested event) async* {
    _feedSubscription?.cancel();
    if (event.loadMore == false) {
      _contents.clear();
      yield FeedLoadInProgress();
    }
    _feedSubscription = _feedRepository
        .getFeed(
      filter: event.filter,
      limit: event.limit,
      after: event.loadMore ? _contents.last.fullname : null,
    )
        .listen(
      (content) {
        _contents.add(content);
      },
      onDone: () {
        add(FeedLoaded(DateTime.now(), _contents));
      },
    );
  }

  Stream<FeedState> _mapFeedRefreshRequestedToState(
      FeedRefreshRequested event) async* {
    _feedSubscription?.cancel();
    _contents.clear();
    yield FeedRefreshInProgress();
    _feedSubscription = _feedRepository
        .getFeed(
      filter: event.filter,
      limit: event.limit,
    )
        .listen(
      (content) {
        _contents.add(content);
      },
      onDone: () {
        add(FeedLoaded(DateTime.now(), _contents));
      },
    );
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
