import 'dart:async';

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    context.read<FeedBloc>().add(FeedRequested(
          subreddit: widget.subredditRef.displayName,
          filter: DEFAULT_SUBREDDIT_FILTER,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subredditRef.displayName),
      ),
      body: Column(
        children: [
          SubredditFeedSwitcher(
            subredditName: widget.subredditRef.displayName,
            selectedFilter: _selectedFilter,
            setSelectedFilter: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
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
                      context.read<FeedBloc>().add(FeedRefreshRequested(
                            subreddit: widget.subredditRef.displayName,
                            filter: _selectedFilter,
                          ));
                      return _refreshCompleter.future;
                    },
                    child: ListView.builder(
                      itemCount: state.feeds.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.feeds.length - NEXT_PAGE_THRESHOLD) {
                          context.read<FeedBloc>().add(FeedRequested(
                                subreddit: widget.subredditRef.displayName,
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
    );
  }
}
