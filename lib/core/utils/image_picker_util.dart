import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract final class ImagePickerUtil {
  /// Pick single image
  static Future<String?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    final xImage = await ImagePicker().pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );

    if (xImage != null) {
      final image = File(xImage.path);
      return image.path;
    }

    return null;
  }
}
