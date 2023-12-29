import 'package:instaclone/state/auth/modals/auth_state.dart';
import 'package:instaclone/state/auth/notifiers/auth_state_notifier.dart';
import 'package:riverpod/riverpod.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
    (_) => AuthStateNotifier());

