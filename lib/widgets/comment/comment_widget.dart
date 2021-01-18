import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/utils/custom_markdown_stylesheet.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentWidget extends StatelessWidget {
  final dynamic comment;

  const CommentWidget({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MarkdownBody(
        data: HtmlUnescape().convert(comment.body),
        onTapLink: (text, link, _) => launch(link),
        styleSheet: customMarkdownStyleSheet,
      ),
    );
  }
}
