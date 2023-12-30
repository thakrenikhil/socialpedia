import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/views/components/rich_text/link_text.dart';

import 'base_text.dart';

class RichTextWigget extends StatelessWidget {
  final Iterable<BaseText> texts;
  final TextStyle? styleforAll;
  const RichTextWigget({super.key, required this.texts, this.styleforAll});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map(
          (baseText) {
            if (baseText is LinkText) {
              return TextSpan(
                text: baseText.text,
                style: styleforAll?.merge(baseText.style),
                recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
              );
            } else {
              return TextSpan(
                text: baseText.text,
                style: styleforAll?.merge(baseText.style),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
