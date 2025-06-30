import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/views/extentions/dissmis_keyboard.dart';

import '../../state/auth/providers/user_id_provider.dart';
import '../../state/comments/modals/post_comment_request.dart';
import '../../state/comments/providers/post_comment_provider.dart';
import '../../state/comments/providers/send_comment_provider.dart';
import '../../state/posts/typedefs/post_id.dart';
import '../components/animations/empty_contents_with_text_animation_view.dart';
import '../components/animations/error_animation_view.dart';
import '../components/animations/loading_animation_view.dart';
import '../components/comment/comment_tile.dart';
import '../components/constants/strings.dart';

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;

  const PostCommentsView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      RequestForPostAndComments(
        postId: postId,
      ),
    );
    final comments = ref.watch(
      postCommentsProvider(
        request.value,
      ),
    );
    // enable Post button when text is entered in the textfield
    useEffect(
      () {
        commentController.addListener(() {
          hasText.value = commentController.text.isNotEmpty;
        });
        return () {};
      },
      [commentController],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // base dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // soft dark gray app bar
        elevation: 0,
        title: const Text(
          Strings.comments,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send,
                color: hasText.value ? Colors.orange : Colors.grey),
            onPressed: hasText.value
                ? () {
                    _submitCommentWithController(commentController, ref);
                  }
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContentsWithTextAnimationView(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () {
                      ref.refresh(postCommentsProvider(request.value));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    color: Colors.orangeAccent,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments.elementAt(index);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CommentTile(comment: comment),
                        );
                      },
                    ),
                  );
                },
                error: (_, __) => const ErrorAnimationView(),
                loading: () => const LoadingAnimationView(),
              ),
            ),
            Container(
              color: const Color(0xFF1A1A1A),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.send,
                onSubmitted: (comment) {
                  if (comment.isNotEmpty) {
                    _submitCommentWithController(commentController, ref);
                  }
                },
                decoration: InputDecoration(
                  hintText: Strings.writeYourCommentHere,
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref
        .read(
          sendCommentProvider.notifier,
        )
        .sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );
    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
