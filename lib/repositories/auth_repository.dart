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
  Box authBox;

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> init() async {
    // Try to read from storage if refresh token is available
    authBox = await Hive.openBox('auth');
    if (authBox.isNotEmpty) {
      final credentials = authBox.get('credentials');
      redditClient = Reddit.restoreAuthenticatedInstance(
        credentials,
        clientId: clientId,
        userAgent: 'flutter-yshean',
      );
      final user = await getUser();
      if (user != null) _controller.add(AuthStatus.authenticated);
    } else {
      // Make sure the data is cleared despite the last logout attempt was successful or not
      await Hive.deleteBoxFromDisk('auth');
      await Hive.deleteBoxFromDisk('cache');
      authBox = await Hive.openBox('auth');
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
    authBox.put('credentials', _authClient.auth.credentials.toJson());
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
    await authBox.deleteFromDisk();
    // Also clear the cache
    await Hive.deleteBoxFromDisk('cache');
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
