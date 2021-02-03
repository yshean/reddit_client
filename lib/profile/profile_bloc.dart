import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/repositories/profile_repository.dart';
import 'package:reddit_client/widgets/profile_section_switcher.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;

  StreamSubscription _authSubscription;
  Map<ProfileSection, StreamSubscription> _feedSubscriptions = {
    ProfileSection.POSTS: null,
    ProfileSection.COMMENTS: null,
    ProfileSection.SAVED: null,
    ProfileSection.HIDDEN: null,
    ProfileSection.UPVOTED: null,
    ProfileSection.DOWNVOTED: null,
  };
  Redditor _redditor;
  ProfileRepository _profileRepository;
  Map<ProfileSection, List<dynamic>> _contents = {
    ProfileSection.POSTS: [],
    ProfileSection.COMMENTS: [],
    ProfileSection.SAVED: [],
    ProfileSection.HIDDEN: [],
    ProfileSection.UPVOTED: [],
    ProfileSection.DOWNVOTED: [],
  };

  ProfileBloc({@required this.authBloc})
      : super(ProfileContentLoadInProgress(DEFAULT_PROFILE_SECTION)) {
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
        section: event.section,
      );
    } else if (event is ProfileContentRefreshRequested) {
      yield* _mapProfileContentRefreshRequestedToState(event);
    }
  }

  Stream<ProfileState> _mapProfileContentRequestedToState(
      ProfileContentRequested event) async* {
    _feedSubscriptions[event.section]?.cancel();
    if (!event.loadMore) {
      _contents[event.section].clear();
      yield ProfileContentLoadInProgress(event.section);
    }

    Map<ProfileSection, int> _newContentLengths = {
      ProfileSection.POSTS: 0,
      ProfileSection.COMMENTS: 0,
      ProfileSection.SAVED: 0,
      ProfileSection.HIDDEN: 0,
      ProfileSection.UPVOTED: 0,
      ProfileSection.DOWNVOTED: 0,
    };
    Map<ProfileSection, Stream<UserContent>> _contentStreams = {
      ProfileSection.POSTS: _profileRepository?.getPosts(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
      ProfileSection.COMMENTS: _profileRepository?.getComments(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
      ProfileSection.SAVED: _profileRepository?.getSaved(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
      ProfileSection.HIDDEN: _profileRepository?.getHidden(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
      ProfileSection.UPVOTED: _profileRepository?.getUpvoted(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
      ProfileSection.DOWNVOTED: _profileRepository?.getDownvoted(
        filter: event.filter,
        limit: event.limit,
        after: event.loadMore && _contents[event.section].isNotEmpty
            ? _contents[event.section].last.fullname
            : null,
      ),
    };

    _feedSubscriptions[event.section] = _contentStreams[event.section]?.listen(
      (content) {
        _contents[event.section].add(content);
        _newContentLengths[event.section]++;
      },
      onDone: () async {
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents[event.section],
          hasReachedMax: _newContentLengths[event.section] < event.limit,
          section: event.section,
        ));
        _newContentLengths[event.section] = 0;
      },
    );
  }

  Stream<ProfileState> _mapProfileContentRefreshRequestedToState(
      ProfileContentRefreshRequested event) async* {
    _feedSubscriptions[event.section]?.cancel();
    _contents[event.section].clear();
    yield ProfileContentRefreshInProgress(event.section);

    int _newContentLength = 0;
    Map<ProfileSection, Stream<UserContent>> _contentStreams = {
      ProfileSection.POSTS: _profileRepository?.getPosts(
        filter: event.filter,
        limit: event.limit,
      ),
      ProfileSection.COMMENTS: _profileRepository?.getComments(
        filter: event.filter,
        limit: event.limit,
      ),
      ProfileSection.SAVED: _profileRepository?.getSaved(
        filter: event.filter,
        limit: event.limit,
      ),
      ProfileSection.HIDDEN: _profileRepository?.getHidden(
        filter: event.filter,
        limit: event.limit,
      ),
      ProfileSection.UPVOTED: _profileRepository?.getUpvoted(
        filter: event.filter,
        limit: event.limit,
      ),
      ProfileSection.DOWNVOTED: _profileRepository?.getDownvoted(
        filter: event.filter,
        limit: event.limit,
      ),
    };

    _feedSubscriptions[event.section] = _contentStreams[event.section]?.listen(
      (content) {
        _contents[event.section].add(content);
        _newContentLength++;
      },
      onDone: () async {
        _newContentLength = 0;
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents[event.section],
          hasReachedMax: _newContentLength < event.limit,
          section: event.section,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _feedSubscriptions.forEach((section, subscription) {
      subscription?.cancel();
    });
    return super.close();
  }
}
