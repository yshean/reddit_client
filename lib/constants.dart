import 'package:reddit_client/feed/feed_bloc.dart';
import 'package:reddit_client/repositories/profile_repository.dart';
import 'package:reddit_client/widgets/profile_section_switcher.dart';

const NEXT_PAGE_THRESHOLD = 1;

const DEFAULT_FRONT_FILTER = FeedFilter.BEST;

const DEFAULT_SUBREDDIT_FILTER = FeedFilter.HOT;

const DEFAULT_PROFILE_SECTION = ProfileSection.POSTS;

const DEFAULT_PROFILE_FILTER = ProfileContentFilter.NEW;
