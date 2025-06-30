import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/modals/post.dart';
import 'package:instaclone/views/components/animations/error_animation_view.dart';
import 'package:instaclone/views/components/post/post_display_name_and%20_message.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../enum/date_sorting.dart';
import '../../../state/comments/modals/post_comment_request.dart';
import '../../../state/posts/providers/specific_post_with_comments_provider.dart';
import '../../post_comments/post_comments_view.dart';
import '../animations/loading_animation_view.dart';
import '../like_button.dart';

class PostThumbnailViewForScroll extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback onTapped;

  const PostThumbnailViewForScroll({
    super.key,
    required this.onTapped,
    required this.post,
  });

  @override
  ConsumerState<PostThumbnailViewForScroll> createState() =>
      _PostThumbnailViewForScrollState();
}

class _PostThumbnailViewForScrollState
    extends ConsumerState<PostThumbnailViewForScroll> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    final postWithComments = ref.watch(
      specificPostWithCommentsProvider(request),
    );

    return Container(
      color: const Color(0xFF121212), // softer dark background
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: widget.onTapped,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.post.fileUrl,
                fit: BoxFit.cover,
                height: 280,
                width: double.infinity,
                cacheManager: getCacheManager(),
              ),
            ),
          ),
          postWithComments.when(
            data: (postWithComments) {
              final postId = postWithComments.post.postId;
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostDisplayNameAndMessageView(
                      post: postWithComments.post,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (postWithComments.post.allowsLikes)
                          LikeButton(postId: postId),
                        if (postWithComments.post.allowsComments)
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostCommentsView(
                                    postId: postId,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
            error: (_, __) => const ErrorAnimationView(),
            loading: () => const LoadingAnimationView(),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.4,
            height: 20,
            indent: 12,
            endIndent: 12,
          ),
        ],
      ),
    );
  }
}

BaseCacheManager getCacheManager() {
  if (kIsWeb) {
    // Use a web-compatible cache manager or memory cache
    return DefaultCacheManager(); // or a custom one for web
  } else {
    return DefaultCacheManager();
  }
}
