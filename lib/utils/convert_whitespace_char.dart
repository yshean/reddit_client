/// Dart is not planning to add support for Unicode whitespace character
/// See https://github.com/dart-lang/sdk/issues/14071
/// This is a temporary workaround to convert it to a single line break
String convertWhiteSpaceChar(String text) => text.replaceAll("&#x200B;", "\n");
