import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:reddit_client/utils/custom_markdown_stylesheet.dart';
import 'package:url_launcher/url_launcher.dart';

class SelfPostContent extends StatelessWidget {
  final String text;

  const SelfPostContent({Key key, this.text}) : super(key: key);

  /// Dart is not planning to add support for Unicode whitespace character
  /// See https://github.com/dart-lang/sdk/issues/14071
  /// This is a temporary workaround to convert it to a single line break
  String convertWhiteSpaceChar(String text) =>
      text.replaceAll("&#x200B;", "\n");

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: MarkdownBody(
              data: convertWhiteSpaceChar(HtmlUnescape().convert(text)),
              onTapLink: (text, link, title) => launch(link),
              styleSheet: customMarkdownStyleSheet,
            ),
          )
        : Container();
  }
}
