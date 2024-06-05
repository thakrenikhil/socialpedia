import 'package:flutter/material.dart';
import 'package:instaclone/views/components/post/post_thumbnail_view.dart';
import 'package:instaclone/views/post_comments/post_comments_view.dart';
import 'package:instaclone/views/post_detail/post_details_view.dart';

import '../../../state/posts/modals/post.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsGridView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: posts.length,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
            onTapped: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return PostDetailsView(post: post);
                },
              ));
            },
            post: post);
      },
    );
  }
}
