

import 'package:flutter/foundation.dart';
import 'package:instaclone/views/components/rich_text/base_text.dart';

@immutable

class LinkText extends BaseText{
  final VoidCallback onTapped;
   const LinkText({
    required super.text,
    super.style,
    required this.onTapped,
});
}