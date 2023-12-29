import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_state_provider.dart';


final userIdProvider = Provider((ref) => ref.watch(authStateProvider).userId);
