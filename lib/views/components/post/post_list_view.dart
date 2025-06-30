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
      color: const Color(0xFF121212), // Dark base
      child: ListView.separated(
        key: const PageStorageKey('posts-list-view'),
        itemCount: posts.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = posts.elementAt(index);

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            // delay: Duration(milliseconds: index * 40), // staggered effect
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 2,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(12),
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
