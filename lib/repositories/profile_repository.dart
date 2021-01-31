import 'package:draw/draw.dart';

enum ProfileContentFilter { HOT, NEW, TOP }

class ProfileRepository {
  final Redditor redditor; // to be obtained from AuthBloc

  ProfileRepository(this.redditor);

  Stream<UserContent> getPosts({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.submissions.newest(params: params);
  }

  Stream<UserContent> getComments({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.comments.newest(params: params);
  }

  Stream<UserContent> getSaved({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.saved(params: params);
  }

  Stream<UserContent> getHidden({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.hidden(params: params);
  }

  Stream<UserContent> getUpvoted({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.upvoted(params: params);
  }

  Stream<UserContent> getDownvoted({
    int limit,
    String after,
    ProfileContentFilter filter,
  }) {
    final params = {'limit': limit.toString()};
    if (after != null) params['after'] = after;

    return redditor.downvoted(params: params);
  }
}
