import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/app_view.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/repositories/auth_repository.dart';
import 'package:reddit_client/simple_bloc_observer.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  //   Uri initialLink = await getInitialUri();
  //   if (initialLink != null && initialLink.queryParameters["code"] != null) {
  //     final authCode = initialLink.queryParameters["code"];
  //     print('authCode: $authCode');
  //   }
  // } catch (e) {
  //   throw (e);
  // }
  final authRepository = AuthRepository();
  await authRepository.init();

  runApp(MyApp(
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({
    Key key,
    this.authRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository),
        child: AppView(),
      ),
    );
  }
}
