import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/bloc/feed_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/widgets/feed_switcher.dart';

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
                        return ListTile(
                          title: Text(state.feeds[index].title),
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
