import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'link_text.dart';

@immutable
class BaseText {
  final String text;
  final TextStyle? style;

  const BaseText({
    required this.text,
    this.style,
  });

  factory BaseText.plain({
    required String text,
    TextStyle? style = const TextStyle(),
  }) =>
      BaseText(text: text, style: style);

  factory BaseText.link({
    required String text,
    required VoidCallback onTapped,
    TextStyle? style = const TextStyle(
        color: Colors.blue, decoration: TextDecoration.underline),
  }) =>
      LinkText(text: text, style: style, onTapped: onTapped);
}
