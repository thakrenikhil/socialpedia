import 'package:flutter/material.dart';
import 'package:instaclone/views/components/post/post_thumbnail_for_scroll.dart';
import 'package:instaclone/views/post_detail/post_details_view.dart';

import '../../../state/posts/modals/post.dart';

class PostsListView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          final post = posts.elementAt(index);
          return PostThumbnailViewForScroll(
            onTapped: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailsView(post: post),
                ),
              );
            },
            post: post,
          );
        },
      ),
    );
  }
}
