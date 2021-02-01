part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileContentLoadInProgress extends ProfileState {
  final ProfileSection section;

  ProfileContentLoadInProgress(this.section);

  @override
  List<Object> get props => [section];

  @override
  String toString() {
    return 'ProfileContentLoadInProgress(section: $section)';
  }
}

class ProfileContentLoadSuccess extends ProfileState {
  final DateTime updatedAt;
  final List<dynamic> feeds;
  final bool hasReachedMax;
  final ProfileSection section;

  ProfileContentLoadSuccess({
    @required this.updatedAt,
    @required this.feeds,
    @required this.hasReachedMax,
    @required this.section,
  });

  @override
  List<Object> get props => [updatedAt, feeds, hasReachedMax, section];

  @override
  String toString() {
    return 'ProfileContentLoadSuccess(section: $section, feeds: ${feeds.length}, hasReachedMax: $hasReachedMax)';
  }
}

class ProfileContentLoadFailure extends ProfileState {
  final Error error;

  ProfileContentLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileContentRefreshInProgress extends ProfileState {
  final ProfileSection section;

  ProfileContentRefreshInProgress(this.section);

  @override
  List<Object> get props => [section];
}
