import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/constants.dart';
import 'package:reddit_client/post_search/post_search_bloc.dart';
import 'package:reddit_client/widgets/post_card.dart';

class PostSearch extends SearchDelegate<String> {
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
      BlocProvider.of<PostSearchBloc>(context)
          .add(SearchPostRequested(query: query));
      return BlocBuilder<PostSearchBloc, PostSearchState>(
        builder: (context, state) {
          if (state is SearchPostInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchPostSuccess) {
            if (state.result.isEmpty) {
              return Center(child: Text('No result found'));
            }
            return ListView.builder(
              itemCount: state.result.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (!state.hasReachedMax &&
                    index == state.result.length - NEXT_PAGE_THRESHOLD) {
                  context.read<PostSearchBloc>().add(SearchPostRequested(
                        query: query,
                        loadMore: true,
                      ));
                }
                if (index != 0 && index == state.result.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (index < state.result.length) {
                  return PostCard(
                    submission: state.result[index],
                  );
                }
                return null;
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
