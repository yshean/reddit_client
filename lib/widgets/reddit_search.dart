import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/search/search_bloc.dart';

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
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty)
      BlocProvider.of<SearchBloc>(context).add(SearchRequested(query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchSubredditInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SearchSubredditSuccess) {
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(state.result[index].displayName),
              onTap: () {
                close(context, state.result[index].displayName);
              },
            ),
            itemCount: state.result.length,
          );
        }
        return Container();
      },
    );
  }
}
