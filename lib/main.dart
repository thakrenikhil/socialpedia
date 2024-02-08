import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/login.dart';
import 'package:instaclone/state/auth/providers/auth_state_provider.dart';
import 'package:instaclone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instaclone/state/providers/is_loading_proveder.dart';
import 'package:instaclone/views/components/loading/loading_screen.dart';
import 'package:instaclone/views/login/google_button.com.dart';
import 'package:instaclone/views/login/login_view.dart';
import 'package:instaclone/views/main/main_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        indicatorColor: Colors.blue,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Consumer(builder: (context, ref, child) {
        ref.listen<bool>(isLoadingProvider, (_, isLoading) {
          if (isLoading) {
            LoadingScreen.instance().show(context: context, text: 'Loading');
          } else {
            LoadingScreen.instance().hide();
          }
        });
        final isLoggin = ref.watch(isLoggedInProvider);
        if (isLoggin) {
          return const MainView();
        } else {
          return const SignInView();
        }
      }),
    );
  }
}


