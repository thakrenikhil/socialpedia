import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/constants/firebase_collection_name.dart';
import 'package:instaclone/state/constants/firebase_field_name.dart';
import 'package:instaclone/state/likes/models/like.dart';
import 'package:instaclone/state/likes/models/like_dislike_request.dart';

final likeDislikePostProvider =
    FutureProvider.family.autoDispose<bool, LikeDislikeRequest>(
  (ref, LikeDislikeRequest request) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likes)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
        .get();
    final hasLiked = await query.then(
      (snapshot) => snapshot.docs.isNotEmpty,
    );
    if (hasLiked) {
      //delete the like
      try {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
        });
        return true;
      } catch (_) {
        return false;
      }
    } else {
      final like = Like(
          postId: request.postId,
          date: DateTime.now(),
          likedBy: request.likedBy);
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.likes)
            .add(like);
        return true;
      } catch (_) {
        return false;
      }
    }
  },
);
