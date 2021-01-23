import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/subreddit_search/subreddit_search_bloc.dart';
import 'package:reddit_client/widgets/feed_switcher.dart';
import 'package:reddit_client/widgets/post_card.dart';
import 'package:reddit_client/widgets/subreddit_search.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FeedFilter _selectedFilter = DEFAULT_FRONT_FILTER;
  Completer<void> _refreshCompleter;
  final _scrollViewController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              mini: true,
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
      body: NestedScrollView(
        controller: _scrollViewController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                'Frontpage',
                style: TextStyle(
                  color: Color(0xFF014A60),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    context
                        .read<SubredditSearchBloc>()
                        .add(SearchSubredditCleared());
                    showSearch(
                      context: context,
                      delegate: SubredditSearch(),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: FeedSwitcher(
                  selectedFilter: _selectedFilter,
                  setSelectedFilter: (filter) {
                    setState(() {
                      _selectedFilter = filter;
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
            BlocConsumer<FeedBloc, FeedState>(
              listener: (context, state) {
                if (state is FeedLoadSuccess) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                }
              },
              buildWhen: (_, state) => !(state is FeedRefreshInProgress),
              builder: (context, state) {
                if (state is FeedLoadInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is FeedLoadSuccess) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        context
                            .read<FeedBloc>()
                            .add(FeedRefreshRequested(filter: _selectedFilter));
                        return _refreshCompleter.future;
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels >
                              MediaQuery.of(context).size.height) {
                            setState(() {
                              _showScrollToTopButton = true;
                            });
                          } else {
                            setState(() {
                              _showScrollToTopButton = false;
                            });
                          }
                          return false;
                        },
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: state.feeds.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  state.feeds.length - NEXT_PAGE_THRESHOLD) {
                                context.read<FeedBloc>().add(FeedRequested(
                                      loadMore: true,
                                      filter: _selectedFilter,
                                    ));
                              }
                              if (index == state.feeds.length) {
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
                if (state is FeedLoadFailure) {
                  return Center(
                    child: Text('Oops'),
                  );
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
