import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/utils/custom_markdown_stylesheet.dart';
import 'package:url_launcher/url_launcher.dart';

class SelfPostContent extends StatelessWidget {
  final String text;

  const SelfPostContent({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: MarkdownBody(
              data: HtmlUnescape().convert(text),
              onTapLink: (text, link, title) => launch(link),
              styleSheet: customMarkdownStyleSheet,
            ),
          )
        : Container();
  }
}
