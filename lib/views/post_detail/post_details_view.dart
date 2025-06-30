import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/posts/modals/post.dart';
import 'package:instaclone/views/components/dialogs/alert_dialog_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../enum/date_sorting.dart';
import '../../state/comments/modals/post_comment_request.dart';
import '../../state/posts/providers/can_current_user_delete_post_provider.dart';
import '../../state/posts/providers/delete_post_provider.dart';
import '../../state/posts/providers/specific_post_with_comments_provider.dart';
import '../components/animations/error_animation_view.dart';
import '../components/animations/loading_animation_view.dart';
import '../components/animations/small_error_animation_view.dart';
import '../components/comment/compact_comment_column.dart';
import '../components/constants/strings.dart';
import '../components/dialogs/delete_dialog.dart';
import '../components/like_button.dart';
import '../components/likes_count_view.dart';
import '../components/post/post_date_view.dart';
import '../components/post/post_display_name_and _message.dart';
import '../components/post/post_image_or_video_view.dart';
import '../post_comments/post_comments_view.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
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

    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(widget.post),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // dark mode background
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          Strings.postDetails,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          postWithComments.when(
            data: (postWithComments) {
              return IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  Share.share(
                    postWithComments.post.fileUrl,
                    subject: Strings.checkOutThisPost,
                  );
                },
              );
            },
            error: (_, __) => const SmallErrorAnimationView(),
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          if (canDeletePost.value ?? false)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                  titleOfObjectToDelete: Strings.post,
                )
                    .present(context)
                    .then((shouldDelete) => shouldDelete ?? false);

                if (shouldDeletePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            )
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(post: postWithComments.post),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (postWithComments.post.allowsLikes)
                      LikeButton(postId: postId),
                    const SizedBox(width: 8),
                    if (postWithComments.post.allowsComments)
                      IconButton(
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PostCommentsView(postId: postId),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                PostDisplayNameAndMessageView(post: postWithComments.post),
                const SizedBox(height: 8),
                PostDateView(dateTime: postWithComments.post.createdAt),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                ),
                CompactCommentsColumn(comments: postWithComments.comments),
                if (postWithComments.post.allowsLikes)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: LikesCountView(postId: postId),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        error: (_, __) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
