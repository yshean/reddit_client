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
  // final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.read<SubredditSearchBloc>().add(SearchSubredditCleared());
              showSearch(
                context: context,
                delegate: SubredditSearch(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // TextField(
          //   controller: _controller,
          //   onTap: () async {
          //     // placeholder for our places search later
          //   },
          //   decoration: InputDecoration(
          //     contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //     prefixIcon: Icon(Icons.search),
          //     hintText: "Search...",
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.white, width: 32.0),
          //       borderRadius: BorderRadius.circular(25.0),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.white, width: 32.0),
          //       borderRadius: BorderRadius.circular(25.0),
          //     ),
          //   ),
          // ),
          FeedSwitcher(
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
                      context
                          .read<FeedBloc>()
                          .add(FeedRefreshRequested(filter: _selectedFilter));
                      return _refreshCompleter.future;
                    },
                    child: ListView.builder(
                      itemCount: state.feeds.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.feeds.length - NEXT_PAGE_THRESHOLD) {
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
