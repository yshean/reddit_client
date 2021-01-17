import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/bloc/feed_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/widgets/feed_switcher.dart';
import 'package:reddit_client/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FeedFilter _selectedFilter = DEFAULT_FILTER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit'),
      ),
      body: Column(
        children: [
          FeedSwitcher(
            selectedFilter: _selectedFilter,
            setSelectedFilter: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state is FeedLoadInProgress) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is FeedLoadSuccess) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (index == state.feeds.length - NEXT_PAGE_THRESHOLD) {
                        context.read<FeedBloc>().add(FeedRequested(
                              loadMore: true,
                              filter: _selectedFilter,
                            ));
                      }
                      if (index < state.feeds.length) {
                        final currentFeed = state.feeds[index];
                        return PostCard(
                          title: currentFeed.title,
                          subreddit: currentFeed.subreddit.displayName,
                          author: currentFeed.author,
                          postedAt: currentFeed.createdUtc,
                          commentCount: currentFeed.numComments,
                          upvotes: currentFeed.upvotes,
                          imagePreviewSrc: currentFeed.preview.isEmpty
                              ? null
                              : currentFeed
                                  .preview.first?.resolutions?.first?.url
                                  ?.toString(),
                        );
                      }
                      return null;
                    },
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
