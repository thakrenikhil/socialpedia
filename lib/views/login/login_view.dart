import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../state/auth/providers/auth_state_provider.dart';
import 'google_button.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: const Text(' Sign-In'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const FaIcon(FontAwesomeIcons.instagram,size: 100,),
          const SizedBox(height: 16),
          GoogleBtn1(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
          )
        ]),
      ),
    );
  }
}
