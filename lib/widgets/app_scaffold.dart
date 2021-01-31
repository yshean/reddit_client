import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/repositories/auth_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class AppScaffold extends StatelessWidget {
  final AppBar appBar;
  final Widget body;
  final Widget floatingActionButton;

  const AppScaffold({
    Key key,
    @required this.body,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LogoutSuccess) Navigator.of(context).pop();
          if (state is Authenticated) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, size: 16),
                            Text(
                              'u/${state.user.displayName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            'Karma: ${state.user.linkKarma}/${state.user.commentKarma}'),
                        Text(
                            'Member since ${DateFormat('d MMMM y').format(state.user.createdUtc)}'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                  ),
                  ListTile(
                    title: Text('Frontpage'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/');
                    },
                  ),
                  ListTile(
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/me/posts');
                    },
                  ),
                  ListTile(
                    title: state is LogoutInProgress
                        ? Text('Logging out...')
                        : Text('Logout'),
                    enabled: !(state is LogoutInProgress),
                    onTap: () async {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ),
                ],
              ),
            );
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Text(
                    'Amber for Reddit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                ),
                ListTile(
                  title: Text('Login'),
                  onTap: () async {
                    launch(
                      context
                          .read<AuthRepository>()
                          .generateAuthUrl()
                          .toString(),
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                    // Navigator.of(context).pushReplacementNamed("/profile");
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
