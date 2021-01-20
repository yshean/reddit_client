import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/search/search_bloc.dart';
import 'package:reddit_client/widgets/subreddit_tile.dart';

class RedditSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(SearchRequested(query));
      return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchSubredditInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchSubredditSuccess) {
            if (state.result.isEmpty) {
              return Center(child: Text('No result found'));
            }
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) => SubredditTile(
                subreddit: state.result[index],
              ),
            );
          }
          return Container();
        },
      );
    }
    return Container();
  }
}
