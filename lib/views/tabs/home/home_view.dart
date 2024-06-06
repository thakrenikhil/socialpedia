import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/posts_sliver_grid_view.dart';
import 'package:instaclone/state/posts/providers/all_post_provider.dart';
import 'package:instaclone/views/components/animations/empty_contents_animation_view.dart';
import 'package:instaclone/views/components/post/posts_grid_view.dart';

import '../../../state/providers/is_list_view_provider.dart';
import '../../components/animations/error_animation_view.dart';
import '../../components/animations/loading_animation_view.dart';
import '../../components/post/post_list_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isList = ref.watch(isListViewProvider) ;
    final posts = ref.watch(allPostProvider);
    return RefreshIndicator(
        child: posts.when(data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsAnimationView();
          } else if(isList){
            return PostsListView(posts: posts);
          }else if(!isList){
            return PostsGridView(posts: posts);
          }else{
            return Scaffold(body: CircularProgressIndicator(),);
          }
        }, error: (error, stackTrace) {
          return const ErrorAnimationView();
        }, loading: () {
          return const LoadingAnimationView();
        }),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2));
        });
  }
}
