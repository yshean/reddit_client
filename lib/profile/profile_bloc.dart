import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
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
  StreamSubscription _feedSubscription;
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
  Box _box;

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
    _feedSubscription?.cancel();
    if (!event.loadMore) {
      _contents[event.section].clear();
      yield ProfileContentLoadInProgress(event.section);
    }

    int _newContentLength = 0;
    Stream<UserContent> _contentStream;

    switch (event.section) {
      case ProfileSection.POSTS:
        _contentStream = _profileRepository?.getPosts(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      case ProfileSection.COMMENTS:
        _contentStream = _profileRepository?.getComments(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      case ProfileSection.SAVED:
        _contentStream = _profileRepository?.getSaved(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      case ProfileSection.HIDDEN:
        _contentStream = _profileRepository?.getHidden(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      case ProfileSection.UPVOTED:
        _contentStream = _profileRepository?.getUpvoted(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      case ProfileSection.DOWNVOTED:
        _contentStream = _profileRepository?.getDownvoted(
          filter: event.filter,
          limit: event.limit,
          after: event.loadMore && _contents.isNotEmpty
              ? _contents[event.section].last.fullname
              : null,
        );
        break;
      default:
        break;
    }

    _feedSubscription = _contentStream?.listen(
      (content) {
        _contents[event.section].add(content);
        _newContentLength++;
      },
      onDone: () async {
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents[event.section],
          hasReachedMax: _newContentLength < event.limit,
          section: event.section,
        ));
        _newContentLength = 0;
        // Cache the _contents if the ProfileSection.UPVOTED
        // to save time when checking if the entry is upvoted
        if (event.section == ProfileSection.UPVOTED) {
          final List<String> ids =
              _contents[event.section].map<String>((c) => c.id).toList();
          _box = await Hive.openBox('cache');
          _box.put('upvoted', jsonEncode(ids));
        }
      },
    );
  }

  Stream<ProfileState> _mapProfileContentRefreshRequestedToState(
      ProfileContentRefreshRequested event) async* {
    _feedSubscription?.cancel();
    _contents[event.section].clear();
    yield ProfileContentRefreshInProgress(event.section);

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
        _contents[event.section].add(content);
        _newContentLength++;
      },
      onDone: () {
        add(ProfileContentLoaded(
          updatedAt: DateTime.now(),
          content: _contents[event.section],
          hasReachedMax: _newContentLength < event.limit,
          section: event.section,
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
