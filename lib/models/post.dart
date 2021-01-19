import 'dart:convert';

import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_client/utils/get_post_type.dart';

class Post extends Equatable {
  final String title;
  final String subreddit;
  final String author;
  final DateTime postedAt;
  final int commentCount;
  final int upvotes;
  final num upvoteRatio;
  final PostType postType;
  final String thumbnailSrc;
  final String selfText;
  final Uri url;
  final String domain;
  final CommentForest Function() getComments;
  final Future<CommentForest> Function({CommentSortType sort}) refreshComments;
  final Future<dynamic> Function() refreshPost;

  Post({
    this.title,
    this.subreddit,
    this.author,
    this.postedAt,
    this.commentCount,
    this.upvotes,
    this.upvoteRatio,
    this.postType,
    this.thumbnailSrc,
    this.selfText,
    this.url,
    this.domain,
    this.getComments,
    this.refreshComments,
    this.refreshPost,
  });

  factory Post.fromSubmission(Submission submission) => Post(
        title: submission.title,
        subreddit: submission.subreddit.displayName,
        author: submission.author,
        postedAt: submission.createdUtc,
        commentCount: submission.numComments,
        upvotes: submission.upvotes,
        upvoteRatio: submission.upvoteRatio,
        postType: getPostType(submission),
        thumbnailSrc:
            submission.preview.isEmpty || submission.thumbnail.host == ''
                ? null
                : submission.thumbnail.toString(),
        selfText: submission.selftext,
        url: submission.url,
        domain: submission.domain,
        getComments: () => submission.comments,
        refreshComments: submission.refreshComments,
        refreshPost: submission.refresh,
      );

  Post copyWith({
    String title,
    String subreddit,
    String author,
    DateTime postedAt,
    int commentCount,
    int upvotes,
    num upvoteRatio,
    PostType postType,
    String thumbnailSrc,
    String selfText,
    Uri url,
    String domain,
  }) {
    return Post(
      title: title ?? this.title,
      subreddit: subreddit ?? this.subreddit,
      author: author ?? this.author,
      postedAt: postedAt ?? this.postedAt,
      commentCount: commentCount ?? this.commentCount,
      upvotes: upvotes ?? this.upvotes,
      upvoteRatio: upvoteRatio ?? this.upvoteRatio,
      postType: postType ?? this.postType,
      thumbnailSrc: thumbnailSrc ?? this.thumbnailSrc,
      selfText: selfText ?? this.selfText,
      url: url ?? this.url,
      domain: domain ?? this.domain,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subreddit': subreddit,
      'author': author,
      'postedAt': postedAt?.millisecondsSinceEpoch,
      'commentCount': commentCount,
      'upvotes': upvotes,
      'upvoteRatio': upvoteRatio,
      'postType': postType?.toString(),
      'thumbnailSrc': thumbnailSrc,
      'selfText': selfText,
      // 'url': url?.toMap(),
      'domain': domain,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Post(
      title: map['title'],
      subreddit: map['subreddit'],
      author: map['author'],
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      commentCount: map['commentCount'],
      upvotes: map['upvotes'],
      upvoteRatio: map['upvoteRatio'],
      postType: getPostTypeFromString(map['postType']),
      thumbnailSrc: map['thumbnailSrc'],
      selfText: map['selfText'],
      // url: Uri.fromMap(map['url']),
      domain: map['domain'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      title,
      subreddit,
      author,
      postedAt,
      commentCount,
      upvotes,
      upvoteRatio,
      postType,
      thumbnailSrc,
      selfText,
      url,
      domain,
    ];
  }
}
