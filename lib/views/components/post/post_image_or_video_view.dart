import 'package:flutter/material.dart';
import 'package:instaclone/state/image_upload/modals/file_type.dart';
import 'package:instaclone/views/components/post/post_image_view.dart';
import 'package:instaclone/views/components/post/post_video_view.dart';

import '../../../state/posts/modals/post.dart';

class PostImageOrVideoView extends StatelessWidget {
  final Post post;

  const PostImageOrVideoView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    switch (post.fileType) {
      case FileType.image:
        return PostImageView(post: post);
      case FileType.video:
        return PostVideoView(post: post);

      default:
        return const SizedBox();
    }
  }
}
