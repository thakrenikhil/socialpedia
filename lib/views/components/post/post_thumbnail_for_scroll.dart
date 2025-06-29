import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/modals/post.dart';
import 'package:instaclone/views/components/animations/error_animation_view.dart';
import 'package:instaclone/views/components/post/post_display_name_and%20_message.dart';

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
      limit: 3, // at most 3 comments
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    final postWithComments = ref.watch(
      specificPostWithCommentsProvider(request),
    );

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTapped,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            height: 300,
            width: 300,
            child: Image.network(
              widget.post.fileUrl,
              fit: BoxFit.cover,
              height: 290,
              width: 290,
            ),
          ),
        ),
        postWithComments.when(
          data: (postWithComments) {
            final postId = postWithComments.post.postId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0 ,right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  PostDisplayNameAndMessageView(
                    post: postWithComments.post,

                  ),const Spacer(),
                      // like button if post allows liking it
                      if (postWithComments.post.allowsLikes)
                        LikeButton(
                          postId: postId,
                        ),
                      // comment button if post allows commenting on it
                      if (postWithComments.post.allowsComments)
                        IconButton(
                          icon: const Icon(
                            Icons.mode_comment_outlined,
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
                ),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const ErrorAnimationView();
          },
          loading: () {
            return const LoadingAnimationView();
          },
        ),
        const Divider(
          color: Colors.white,
          height: 30,
        ),
      ],
    );
  }
}
