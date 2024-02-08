import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/image_upload/notifiers/image_upload_notifier.dart';
import 'package:instaclone/state/image_upload/typedefs/is_loading.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUplaodNotifier, IsLoading>(
        (ref) => ImageUplaodNotifier());
