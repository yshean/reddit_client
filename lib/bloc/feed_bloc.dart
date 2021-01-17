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
      yield FeedLoadSuccess(event.content);
    }
  }

  Stream<FeedState> _mapFeedRequestedToState(FeedRequested event) async* {
    _feedSubscription?.cancel();
    if (!(event.loadMore)) {
      _contents.clear();
      yield FeedLoadInProgress();
    }
    _feedSubscription = _feedRepository
        .getFeed(
            filter: event.filter,
            limit: event.limit,
            after: event.loadMore ? _contents.last.fullname : null)
        .listen((content) {
      _contents.add(content);
    }, onDone: () {
      add(FeedLoaded(_contents));
    });
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
