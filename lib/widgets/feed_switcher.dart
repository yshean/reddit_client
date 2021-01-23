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
            color: Color(0xFF014A60),
            fillColor: Colors.white,
            selectedColor: Color(0xFF014A60),
            borderRadius: BorderRadius.circular(5),
            constraints: BoxConstraints.expand(
              width: (constraints.maxWidth - 16) / 5,
              height: 26,
            ),
            children: [
              Text('Best'),
              Text('Hot'),
              Text('New'),
              Text('Top'),
              Text('Rising'),
            ],
            onPressed: (index) {
              switch (index) {
                case 0:
                  setSelectedFilter(FeedFilter.BEST);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.BEST));
                  break;
                case 1:
                  setSelectedFilter(FeedFilter.HOT);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.HOT));
                  break;
                case 2:
                  setSelectedFilter(FeedFilter.NEW);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.NEW));
                  break;
                case 3:
                  setSelectedFilter(FeedFilter.TOP);
                  context
                      .read<FeedBloc>()
                      .add(FeedRequested(filter: FeedFilter.TOP));
                  break;
                case 4:
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
              selectedFilter == FeedFilter.BEST,
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
