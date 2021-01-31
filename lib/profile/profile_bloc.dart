import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/repositories/profile_repository.dart';
import 'package:reddit_client/widgets/profile_section_switcher.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;

  StreamSubscription _authSubscription;
  StreamSubscription _feedSubscription;
  Redditor _redditor;
  ProfileRepository _profileRepository;
  List<Submission> _contents = [];

  ProfileBloc({@required this.authBloc})
      : super(ProfileContentLoadInProgress()) {
    _authSubscription = authBloc.listen((state) {
      if (state is Authenticated) {
        _redditor = state.user;
        _profileRepository = ProfileRepository(_redditor);
      }
    });
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileContentRequested) {
      yield* _mapProfileContentRequestedToState(event);
    } else if (event is ProfileContentLoaded) {
      yield ProfileContentLoadSuccess(
        feeds: event.content,
        hasReachedMax: event.hasReachedMax,
        updatedAt: event.updatedAt,
      );
    } else if (event is ProfileContentRefreshRequested) {
      yield* _mapProfileContentRefreshRequestedToState(event);
    }
  }

  Stream<ProfileState> _mapProfileContentRequestedToState(
      ProfileContentRequested event) async* {
    _feedSubscription?.cancel();
    if (!event.loadMore) {
      _contents.clear();
      yield ProfileContentLoadInProgress();
    }

    int _newContentLength = 0;
    Stream<UserContent> _contentStream;

    switch (event.section) {
      case ProfileSection.POSTS:
        _contentStream = _profileRepository?.getPosts(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      case ProfileSection.COMMENTS:
        _contentStream = _profileRepository?.getComments(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      case ProfileSection.SAVED:
        _contentStream = _profileRepository?.getSaved(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      case ProfileSection.HIDDEN:
        _contentStream = _profileRepository?.getHidden(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      case ProfileSection.UPVOTED:
        _contentStream = _profileRepository?.getUpvoted(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      case ProfileSection.DOWNVOTED:
        _contentStream = _profileRepository?.getDownvoted(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents.last.fullname
              : null,
        );
        break;
      default:
        break;
    }

    _feedSubscription = _contentStream?.listen(
      (content) {
        _contents.add(content);
        _newContentLength++;
      },
      onDone: () {
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents,
          hasReachedMax: _newContentLength < event.limit,
        ));
        _newContentLength = 0;
      },
    );
  }

  Stream<ProfileState> _mapProfileContentRefreshRequestedToState(
      ProfileContentRefreshRequested event) async* {
    _feedSubscription?.cancel();
    _contents.clear();
    yield ProfileContentRefreshInProgress();

    int _newContentLength = 0;
    Stream<UserContent> _contentStream;

    switch (event.section) {
      case ProfileSection.POSTS:
        _contentStream = _profileRepository?.getPosts(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      case ProfileSection.COMMENTS:
        _contentStream = _profileRepository?.getComments(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      case ProfileSection.SAVED:
        _contentStream = _profileRepository?.getSaved(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      case ProfileSection.HIDDEN:
        _contentStream = _profileRepository?.getHidden(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      case ProfileSection.UPVOTED:
        _contentStream = _profileRepository?.getUpvoted(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      case ProfileSection.DOWNVOTED:
        _contentStream = _profileRepository?.getDownvoted(
          filter: event.filter,
          limit: event.limit,
        );
        break;
      default:
        break;
    }

    _feedSubscription = _contentStream?.listen(
      (content) {
        _contents.add(content);
        _newContentLength++;
      },
      onDone: () {
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents,
          hasReachedMax: _newContentLength < event.limit,
        ));
        _newContentLength = 0;
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _feedSubscription?.cancel();
    return super.close();
  }
}
