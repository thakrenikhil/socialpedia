import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:instaclone/state/constants/firebase_collection_name.dart';
import 'package:instaclone/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instaclone/state/image_upload/extentions/get_collection_name_from_file_type.dart';
import 'package:instaclone/state/image_upload/extentions/get_image_data_aspect_ratio.dart';
import 'package:instaclone/state/image_upload/modals/file_type.dart';
import 'package:instaclone/state/image_upload/typedefs/is_loading.dart';
import 'package:instaclone/state/posts/modals/post_payload.dart';
import 'package:instaclone/state/posts/typedefs/user_id.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../views/components/constants/strings.dart';
import '../../post_settings/models/post_setting.dart';

class ImageUplaodNotifier extends StateNotifier<IsLoading> {
  ImageUplaodNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;
    late Uint8List thumbnailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        final thumbnail =
            img.copyResize(fileAsImage, width: Strings.imageThumbnailWidth);
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;

      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: Strings.videoThumbnailMaxHeight,
            quality: Strings.videoThumbnailQuality);
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        break;
    }
    //calculate aspect ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();
    //calculate reference
    final fileName = const Uuid().v4();

    //create reference to thumbnail and the image itself

    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      // upload the thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //upload the original file
      final originalFileUplaodTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUplaodTask.ref.name;

      //upload the post itself

      final postPayload = PostPayload(
          userId: userId,
          message: message,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileType: fileType,
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
          postSettings: postSettings);
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
