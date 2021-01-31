import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/auth/auth_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/profile/profile_bloc.dart';
import 'package:reddit_client/widgets/app_scaffold.dart';
import 'package:reddit_client/widgets/post_card.dart';
import 'package:reddit_client/widgets/profile_section_switcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scrollViewController = ScrollController();
  ProfileSection _selectedSection = DEFAULT_PROFILE_SECTION;
  Completer<void> _refreshCompleter;
  bool _showScrollToTopButton = false;

  Future<void> onRefresh() {
    context.read<ProfileBloc>().add(ProfileContentRefreshRequested(
          section: _selectedSection,
          filter: DEFAULT_PROFILE_FILTER,
        ));
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    context.read<ProfileBloc>().add(ProfileContentRequested(
          section: DEFAULT_PROFILE_SECTION,
          filter: DEFAULT_PROFILE_FILTER,
        ));
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              child: Icon(Icons.keyboard_arrow_up),
              onPressed: () {
                _scrollViewController.animateTo(
                  0,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                );
              },
            )
          : null,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated || state is AuthUnknown) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        child: NestedScrollView(
          controller: _scrollViewController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated)
                      return Text(
                        'u/${state.user.displayName}',
                        style: TextStyle(
                          color: Color(0xFF014A60),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    return Text('Profile');
                  },
                ),
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      CheckedPopupMenuItem(
                        child: Text('Hidden'),
                        checked: _selectedSection == ProfileSection.HIDDEN,
                        value: ProfileSection.HIDDEN,
                      ),
                      CheckedPopupMenuItem(
                        child: Text('Upvoted'),
                        checked: _selectedSection == ProfileSection.UPVOTED,
                        value: ProfileSection.UPVOTED,
                      ),
                      CheckedPopupMenuItem(
                        child: Text('Downvoted'),
                        checked: _selectedSection == ProfileSection.DOWNVOTED,
                        value: ProfileSection.DOWNVOTED,
                      ),
                    ],
                    onSelected: (ProfileSection section) {
                      if (section == ProfileSection.HIDDEN) {
                        setState(() {
                          _selectedSection = ProfileSection.HIDDEN;
                        });
                        context.read<ProfileBloc>().add(ProfileContentRequested(
                              section: ProfileSection.HIDDEN,
                              filter: DEFAULT_PROFILE_FILTER,
                            ));
                      }
                      if (section == ProfileSection.UPVOTED) {
                        setState(() {
                          _selectedSection = ProfileSection.UPVOTED;
                        });
                        context.read<ProfileBloc>().add(ProfileContentRequested(
                              section: ProfileSection.UPVOTED,
                              filter: DEFAULT_PROFILE_FILTER,
                            ));
                      }
                      if (section == ProfileSection.DOWNVOTED) {
                        setState(() {
                          _selectedSection = ProfileSection.DOWNVOTED;
                        });
                        context.read<ProfileBloc>().add(ProfileContentRequested(
                              section: ProfileSection.DOWNVOTED,
                              filter: DEFAULT_PROFILE_FILTER,
                            ));
                      }
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30),
                  child: ProfileSectionSwitcher(
                    selectedSection: _selectedSection,
                    setSelectedSection: (section) {
                      setState(() {
                        _selectedSection = section;
                      });
                      _scrollViewController.jumpTo(0);
                    },
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileContentLoadSuccess) {
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                  }
                },
                builder: (context, state) {
                  if (state is ProfileContentLoadInProgress ||
                      state is ProfileContentRefreshInProgress) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is ProfileContentLoadSuccess) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: onRefresh,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!_showScrollToTopButton &&
                                scrollInfo.metrics.pixels >=
                                    MediaQuery.of(context).size.height) {
                              setState(() {
                                _showScrollToTopButton = true;
                              });
                            }
                            if (_showScrollToTopButton &&
                                scrollInfo.metrics.pixels <
                                    MediaQuery.of(context).size.height) {
                              setState(() {
                                _showScrollToTopButton = false;
                              });
                            }
                            return false;
                          },
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: state.feeds.length == 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Nothing here'),
                                      SizedBox(height: 8),
                                      RaisedButton(
                                        onPressed: onRefresh,
                                        child: Text('Refresh'),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount: state.feeds.length +
                                        (state.hasReachedMax ? 0 : 1),
                                    itemBuilder: (context, index) {
                                      if (!state.hasReachedMax &&
                                          index ==
                                              state.feeds.length -
                                                  NEXT_PAGE_THRESHOLD) {
                                        context
                                            .read<ProfileBloc>()
                                            .add(ProfileContentRequested(
                                              section: _selectedSection,
                                              loadMore: true,
                                              filter: DEFAULT_PROFILE_FILTER,
                                            ));
                                      }
                                      if (index != 0 &&
                                          index == state.feeds.length) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      if (index < state.feeds.length) {
                                        final submission = state.feeds[index];
                                        return PostCard(submission: submission);
                                      }
                                      return null;
                                    },
                                  ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is ProfileContentLoadFailure) {
                    return Expanded(
                      child: Center(
                        child: Text('Oops'),
                      ),
                    );
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
