import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_client/feed/feed_bloc.dart';

class FeedSwitcher extends StatelessWidget {
  const FeedSwitcher({
    Key key,
    @required this.selectedFilter,
    @required this.setSelectedFilter,
  }) : super(key: key);

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
              width: (constraints.maxWidth - 16) / 3,
              height: 26,
            ),
            children: [
              Text('Hot'),
              Text('New'),
              Text('Rising'),
            ],
            onPressed: (index) {
              switch (index) {
                case 0:
                  setSelectedFilter(FeedFilter.HOT);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.HOT));
                  break;
                case 1:
                  setSelectedFilter(FeedFilter.NEW);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.NEW));
                  break;
                case 2:
                  setSelectedFilter(FeedFilter.RISING);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.RISING));
                  break;
                default:
                  break;
              }
            },
            isSelected: [
              selectedFilter == FeedFilter.HOT,
              selectedFilter == FeedFilter.NEW,
              selectedFilter == FeedFilter.RISING,
            ],
          ),
        ),
      ),
    );
  }
}
