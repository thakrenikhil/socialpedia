import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instaclone/views/components/animations/error_animation_view.dart';
import 'package:instaclone/views/components/animations/loading_animation_view.dart';
import 'package:video_player/video_player.dart';

import '../../../state/posts/modals/post.dart';

class PostVideoView extends HookWidget {
  final Post post;

  const PostVideoView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.networkUrl(post.fileUrl as Uri);
    final isVideoPlayerReady = useState(false);
    useEffect(() {
      controller.initialize().then((value) {
        isVideoPlayerReady.value = true;
        controller.setLooping(true);
      });
      return controller.dispose;
    });
    switch (isVideoPlayerReady) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );
      case false:
        return const LoadingAnimationView();
      default:
        return const ErrorAnimationView();
    }
    return const Placeholder();
  }
}
