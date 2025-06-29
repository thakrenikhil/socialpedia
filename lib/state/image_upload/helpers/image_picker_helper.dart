import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/state/image_upload/extentions/to_file.dart';

@immutable
class ImagePickerhelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImageFromgallery() =>
      _imagePicker.pickImage(source: ImageSource.gallery).toFile();

  static Future<File?> pickVideoFromgallery() =>
      _imagePicker.pickVideo(source: ImageSource.gallery).toFile();
}
