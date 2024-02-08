import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/providers/user_posts_provider.dart';
import 'package:instaclone/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instaclone/views/components/animations/error_animation_view.dart';
import 'package:instaclone/views/components/animations/loading_animation_view.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/post/posts_grid_view.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
        child: posts.when(data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
                text: Strings.youHaveNoPosts);
          } else {
            return PostsGridView(posts: posts);
          }
        }, error: (error, stackTrace) {
          return const ErrorAnimationView();
        }, loading: () {
          return const LoadingAnimationView();
        }),
        onRefresh: () {
          ref.refresh(userPostsProvider);
          return Future.delayed(const Duration(seconds: 2));
        });
  }
}
