part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileContentLoadInProgress extends ProfileState {}

class ProfileContentLoadSuccess extends ProfileState {
  final DateTime updatedAt;
  final List<Submission> feeds;
  final bool hasReachedMax;

  ProfileContentLoadSuccess({
    @required this.updatedAt,
    @required this.feeds,
    @required this.hasReachedMax,
  });

  @override
  List<Object> get props => [updatedAt, feeds, hasReachedMax];
}

class ProfileContentLoadFailure extends ProfileState {
  final Error error;

  ProfileContentLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileContentRefreshInProgress extends ProfileState {}
