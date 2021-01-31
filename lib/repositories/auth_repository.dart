import 'dart:async';

import 'package:draw/draw.dart';
import 'package:hive/hive.dart';
import 'package:reddit_client/secrets.dart';
import 'package:uuid/uuid.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  Reddit redditClient;
  Redditor _user;
  final _controller = StreamController<AuthStatus>();
  Reddit _authClient;
  Box box;

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> init() async {
    // Try to read from storage if refresh token is available
    box = await Hive.openBox('auth');
    if (box.isNotEmpty) {
      final credentials = box.get('credentials');
      redditClient = Reddit.restoreAuthenticatedInstance(
        credentials,
        clientId: clientId,
        userAgent: 'flutter-yshean',
      );
      _controller.add(AuthStatus.authenticated);
    } else {
      redditClient = await Reddit.createUntrustedReadOnlyInstance(
        clientId: clientId,
        userAgent: 'flutter-yshean',
        deviceId: Uuid().v4(),
      );
    }
  }

  Uri generateAuthUrl() {
    _authClient = Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: "flutter-yshean",
      redirectUri: Uri.parse("amberforreddit://yshean.com"),
    );
    return _authClient.auth.url(['*'], "amber-dev");
  }

  Future<void> login(String authCode) async {
    await _authClient.auth.authorize(authCode);
    // Save the credentials on device
    box.put('credentials', _authClient.auth.credentials.toJson());
    redditClient = _authClient;
    _controller.add(AuthStatus.authenticated);
  }

  Future<void> logout() async {
    redditClient = await Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: 'flutter-yshean',
      deviceId: Uuid().v4(),
    );
    // Clear the credentials on device
    await box.deleteFromDisk();
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
