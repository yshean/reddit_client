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
  final List<dynamic> content;
  final bool hasReachedMax;
  final ProfileSection section;

  ProfileContentLoaded({
    @required this.updatedAt,
    @required this.content,
    @required this.hasReachedMax,
    @required this.section,
  });

  @override
  List<Object> get props => [updatedAt, content, hasReachedMax, section];

  @override
  String toString() {
    return 'ProfileContentLoaded(section: $section)';
  }
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
