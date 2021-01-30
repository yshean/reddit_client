part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileContentRequested extends ProfileEvent {
  final ProfileSection section;
  final int limit;
  final ProfileContentFilter filter;
  final bool loadMore;

  ProfileContentRequested({
    @required this.section,
    this.limit = 10,
    @required this.filter,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [section, limit, filter, loadMore];

  @override
  String toString() {
    return 'ProfileContentRequested(section: $section, limit: $limit, filter: $filter, loadMore: $loadMore)';
  }
}

class ProfileContentLoaded extends ProfileEvent {
  final DateTime updatedAt;
  final List<Submission> content;
  final bool hasReachedMax;

  ProfileContentLoaded({
    @required this.updatedAt,
    @required this.content,
    @required this.hasReachedMax,
  });

  @override
  List<Object> get props => [updatedAt, content, hasReachedMax];
}

class ProfileContentRefreshRequested extends ProfileEvent {
  final ProfileSection section;
  final int limit;
  final ProfileContentFilter filter;

  ProfileContentRefreshRequested({
    @required this.section,
    this.limit = 10,
    @required this.filter,
  });

  @override
  List<Object> get props => [section, limit, filter];
}
