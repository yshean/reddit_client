part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final AuthStatus status;
  final Redditor user;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
  });

  @override
  List<Object> get props => [status, user];
}

class AuthUnknown extends AuthState {}

class Authenticated extends AuthState {
  final Redditor user;

  Authenticated(this.user)
      : super(
          status: AuthStatus.authenticated,
          user: user,
        );
}

class Unauthenticated extends AuthState {
  Unauthenticated() : super(status: AuthStatus.unauthenticated);
}

class LogoutInProgress extends AuthState {
  LogoutInProgress() : super(status: AuthStatus.unauthenticated);
}

class LogoutSuccess extends AuthState {
  LogoutSuccess() : super(status: AuthStatus.unauthenticated);
}
