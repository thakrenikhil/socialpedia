import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/providers/post_by_search_term_provider.dart';
import 'package:instaclone/views/components/animations/data_not_found_animation_view.dart';
import 'package:instaclone/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instaclone/views/components/animations/error_animation_view.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/post/posts_grid_view.dart';

class SearchGridView extends ConsumerWidget {
  final String searchTerm;

  const SearchGridView({super.key, required this.searchTerm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentsWithTextAnimationView(
            text: Strings.enterYourSearchTerm),
      );
    }

    final posts = ref.watch(postsBySearchTermProvider(searchTerm));
    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(child: DataNotFoundAnimationView());
        } else {
          return SliverToBoxAdapter(child: PostsGridView(posts: posts));
        }
      },
      error: (error, stackTrace) =>
          const SliverToBoxAdapter(child: ErrorAnimationView()),
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
