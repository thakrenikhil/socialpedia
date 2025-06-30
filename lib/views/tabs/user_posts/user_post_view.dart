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

    return Container(
      color: const Color(0xFF121212), // Dark background
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () {
          ref.refresh(userPostsProvider);
          return Future.delayed(const Duration(seconds: 2));
        },
        child: posts.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500, // ensure enough space to trigger refresh
                  child: Center(
                    child: EmptyContentsWithTextAnimationView(
                      text: Strings.youHaveNoPosts,
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PostsGridView(posts: posts),
              );
            }
          },
          error: (_, __) => const ErrorAnimationView(),
          loading: () => const LoadingAnimationView(),
        ),
      ),
    );
  }
}
