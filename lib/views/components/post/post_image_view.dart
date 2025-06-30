import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../state/posts/modals/post.dart';

class PostImageView extends StatelessWidget {
  final Post post;

  const PostImageView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: post.aspectRatio,
        child: CachedNetworkImage(
          imageUrl: post.fileUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.white),
          height: 300,
          width: double.infinity,
        ));
  }
}
