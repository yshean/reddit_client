import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/post_search/post_search_bloc.dart';
import 'package:reddit_client/subreddit_search/subreddit_search_bloc.dart';
import 'package:reddit_client/widgets/post_search.dart';
import 'package:reddit_client/widgets/subreddit_tile.dart';

class SubredditSearch extends SearchDelegate<String> {
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
      BlocProvider.of<SubredditSearchBloc>(context)
          .add(SearchSubredditRequested(query));
      return BlocBuilder<SubredditSearchBloc, SubredditSearchState>(
        builder: (context, state) {
          if (state is SearchSubredditInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchSubredditSuccess) {
            if (state.result.isEmpty) {
              return SearchPostLink(query);
            }
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                if (index == state.result.length - 1)
                  return SearchPostLink(query);
                return SubredditTile(
                  subreddit: state.result[index],
                );
              },
            );
          }
          return Container();
        },
      );
    }
    return Container();
  }
}

class SearchPostLink extends StatelessWidget {
  final String query;

  const SearchPostLink(this.query);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Posts with "$query..."',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        context.read<PostSearchBloc>().add(SearchPostCleared());
        showSearch(
          query: query,
          context: context,
          delegate: PostSearch(),
        );
      },
    );
  }
}
