import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart' as material show Image;
import 'package:instaclone/state/image_upload/extentions/get_image_aspect_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() {
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
