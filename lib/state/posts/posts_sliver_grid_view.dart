import 'package:flutter/material.dart';

import '../../views/components/post/post_thumbnail_view.dart';
import '../../views/post_detail/post_details_view.dart';
import 'modals/post.dart';

class PostsSliverGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsSliverGridView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(childCount: posts.length,(context, index) {
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
        },),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisExtent: 8, crossAxisSpacing: 8));
  }
}
