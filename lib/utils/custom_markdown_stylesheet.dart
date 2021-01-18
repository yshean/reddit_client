import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final ThemeData textTheme = ThemeData(
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontSize: 12.0,
      fontFamily: "Raleway",
    ),
  ),
);

MarkdownStyleSheet customMarkdownStyleSheet = MarkdownStyleSheet.fromTheme(
  textTheme,
).copyWith(
  blockquoteDecoration: BoxDecoration(
    // color: Colors.grey,
    borderRadius: BorderRadius.circular(2.0),
  ),
  code: textTheme.textTheme.bodyText2.copyWith(
    // backgroundColor: Colors.grey,
    fontFamily: "monospace",
    fontSize: textTheme.textTheme.bodyText2.fontSize * 0.85,
  ),
  codeblockPadding: const EdgeInsets.all(8.0),
  codeblockDecoration: BoxDecoration(
    // color: Colors.grey,
    borderRadius: BorderRadius.circular(2.0),
  ),
  tableCellsDecoration: BoxDecoration(
      // color: Colors.grey,
      ),
);
