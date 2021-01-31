import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  // Initialise Hive
  await Hive.initFlutter();

  final authRepository = AuthRepository();

  runZonedGuarded(() async {
    await authRepository.init();
    runApp(MyApp(
      authRepository: authRepository,
    ));
  }, (exception, stackTrace) async {
    if (exception is FormatException &&
        exception.message.contains('"error": 401')) {
      print('force logout');
      await authRepository.logout();
    }
  });
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
