import 'dart:async';

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/subreddit/subreddit_bloc.dart';
import 'package:reddit_client/widgets/post_card.dart';
import 'package:reddit_client/widgets/subreddit_feed_switcher.dart';

class SubredditScreen extends StatefulWidget {
  final SubredditRef subredditRef;

  const SubredditScreen({Key key, this.subredditRef}) : super(key: key);

  @override
  _SubredditScreenState createState() => _SubredditScreenState();
}

class _SubredditScreenState extends State<SubredditScreen> {
  FeedFilter _selectedFilter = DEFAULT_SUBREDDIT_FILTER;
  Completer<void> _refreshCompleter;
  final _scrollViewController = ScrollController();
  bool _showScrollToTopButton = false;
  final _slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    context.read<SubredditBloc>().add(SubredditFeedRequested(
          subreddit: widget.subredditRef.displayName,
          filter: DEFAULT_SUBREDDIT_FILTER,
        ));
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
                widget.subredditRef.displayName,
                style: TextStyle(
                  color: Color(0xFF014A60),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: SubredditFeedSwitcher(
                  subredditName: widget.subredditRef.displayName,
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
            BlocConsumer<SubredditBloc, SubredditState>(
              listener: (context, state) {
                if (state is SubredditFeedLoadSuccess) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                }
              },
              // TODO: Somehow the content does not refresh
              // buildWhen: (_, state) =>
              //     !(state is SubredditFeedRefreshInProgress),
              builder: (context, state) {
                if (state is SubredditFeedLoadInProgress ||
                    state is SubredditFeedRefreshInProgress) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is SubredditFeedLoadSuccess) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        context
                            .read<SubredditBloc>()
                            .add(SubredditFeedRefreshRequested(
                              subreddit: widget.subredditRef.displayName,
                              filter: _selectedFilter,
                            ));
                        return _refreshCompleter.future;
                      },
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
                          child: ListView.builder(
                            itemCount: state.feeds.length +
                                (state.hasReachedMax ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (!state.hasReachedMax &&
                                  index ==
                                      state.feeds.length -
                                          NEXT_PAGE_THRESHOLD) {
                                context
                                    .read<SubredditBloc>()
                                    .add(SubredditFeedRequested(
                                      subreddit:
                                          widget.subredditRef.displayName,
                                      loadMore: true,
                                      filter: _selectedFilter,
                                    ));
                              }
                              if (index != 0 && index == state.feeds.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (index < state.feeds.length) {
                                final submission = state.feeds[index];
                                return PostCard(
                                  submission: submission,
                                  slidableController: _slidableController,
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (state is SubredditFeedLoadFailure) {
                  return Expanded(
                    child: Center(
                      child: Text('Oops'),
                    ),
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
