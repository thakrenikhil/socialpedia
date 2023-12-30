import 'package:flutter/material.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/rich_text/base_text.dart';
import 'package:instaclone/views/components/rich_text/rich_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginViewSignupLink extends StatelessWidget {
  const LoginViewSignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWigget(
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        const BaseText(
          text: Strings.signUpOn,
        ),
        BaseText.link(
          text: Strings.google,
          onTapped: () {
            launchUrl(Uri.parse(Strings.googleSignupUrl));
          },
        )
      ],
      styleforAll:
          Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5),
    );
  }
}
