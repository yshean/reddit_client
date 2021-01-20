import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/subreddit/subreddit_bloc.dart';

class SubredditFeedSwitcher extends StatelessWidget {
  const SubredditFeedSwitcher({
    Key key,
    @required this.subredditName,
    @required this.selectedFilter,
    @required this.setSelectedFilter,
  }) : super(key: key);

  final String subredditName;
  final FeedFilter selectedFilter;
  final void Function(FeedFilter) setSelectedFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => ToggleButtons(
            borderRadius: BorderRadius.circular(5),
            constraints: BoxConstraints.expand(
              width: (constraints.maxWidth - 16) / 5,
              height: 26,
            ),
            children: [
              Text('Hot'),
              Text('New'),
              Text('Top'),
              Text('Rising'),
            ],
            onPressed: (index) {
              switch (index) {
                case 0:
                  setSelectedFilter(FeedFilter.HOT);
                  context.read<SubredditBloc>().add(SubredditFeedRequested(
                        subreddit: subredditName,
                        filter: FeedFilter.HOT,
                      ));
                  break;
                case 1:
                  setSelectedFilter(FeedFilter.NEW);
                  context.read<SubredditBloc>().add(SubredditFeedRequested(
                        subreddit: subredditName,
                        filter: FeedFilter.NEW,
                      ));
                  break;
                case 2:
                  setSelectedFilter(FeedFilter.TOP);
                  context.read<SubredditBloc>().add(SubredditFeedRequested(
                        subreddit: subredditName,
                        filter: FeedFilter.TOP,
                      ));
                  break;
                case 3:
                  setSelectedFilter(FeedFilter.RISING);
                  context.read<SubredditBloc>().add(SubredditFeedRequested(
                        subreddit: subredditName,
                        filter: FeedFilter.RISING,
                      ));
                  break;
                default:
                  break;
              }
            },
            isSelected: [
              selectedFilter == FeedFilter.HOT,
              selectedFilter == FeedFilter.NEW,
              selectedFilter == FeedFilter.TOP,
              selectedFilter == FeedFilter.RISING,
            ],
          ),
        ),
      ),
    );
  }
}
