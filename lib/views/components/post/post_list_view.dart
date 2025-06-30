import 'package:flutter/material.dart';
import 'package:instaclone/views/components/post/post_thumbnail_for_scroll.dart';
import 'package:instaclone/views/post_detail/post_details_view.dart';
import '../../../state/posts/modals/post.dart';

class PostsListView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // softer dark background
      child: ListView.separated(
        key: const PageStorageKey('posts-list-view'),
        itemCount: posts.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final post = posts.elementAt(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              ),
              child: PostThumbnailViewForScroll(
                onTapped: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostDetailsView(post: post),
                    ),
                  );
                },
                post: post,
              ),
            ),
          );
        },
      ),
    );
  }
}
