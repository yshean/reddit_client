import 'dart:async';

import 'package:draw/draw.dart';
import 'package:reddit_client/secrets.dart';
import 'package:uuid/uuid.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  Reddit redditClient;
  Redditor _user;
  final _controller = StreamController<AuthStatus>();
  Reddit _authClient = Reddit.createInstalledFlowInstance(
    clientId: clientId,
    userAgent: "flutter-yshean",
    redirectUri: Uri.parse("amberforreddit://yshean.com"),
  );

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> init() async {
    // TODO: Can also try to read from storage if refresh token is available
    redditClient = await Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: 'flutter-yshean',
      deviceId: Uuid().v4(),
    );
  }

  Uri generateAuthUrl() {
    return _authClient.auth.url(['*'], "amber-dev");
  }

  Future<void> login(String authCode) async {
    await _authClient.auth.authorize(authCode);
    // TODO: Save the refresh token on device
    redditClient = _authClient;
    _controller.add(AuthStatus.authenticated);
  }

  Future<void> logout() async {
    redditClient = await Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: 'flutter-yshean',
      deviceId: Uuid().v4(),
    );
    // TODO: Clear the refresh token on device
    _authClient = Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: "flutter-yshean",
      redirectUri: Uri.parse("amberforreddit://yshean.com"),
    );
    _controller.add(AuthStatus.unauthenticated);
  }

  Future<Redditor> getUser() async {
    if (_user != null) return _user;
    _user = await redditClient.user.me();
    return _user;
  }

  void dispose() => _controller.close();
}
