import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/auth/providers/auth_state_provider.dart';
import 'package:instaclone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instaclone/state/providers/is_loading_proveder.dart';
import 'package:instaclone/views/components/loading/loading_screen.dart';
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
          if(isLoading){
            LoadingScreen.instance().show(context: context,text: 'Loading');
          }else{
            LoadingScreen.instance().hide();
          }

        });
        final isLoggin = ref.watch(isLoggedInProvider);
        if (isLoggin) {
          return const MainView();
        } else {
          return const LoginView();
        }
      }),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Homepage')),
        body: Scaffold(
          body: Center(
            child: Column(children: [
              const CircularProgressIndicator(),
              const Spacer(),
              Consumer(builder: (_, ref, child) {
                return ElevatedButton(
                    onPressed: () async {
                      await ref.read(authStateProvider.notifier).logout();
                    },
                    child: const Text('LogOut'));
              }),
            ]),
          ),
        ));
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.google),
                    SizedBox(width: 8),
                    Text('Sign in with Google'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
