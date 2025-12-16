import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressionService {
  /// Compress image to be within the specified size limit (in KB)
  /// Default max size is 2048 KB (2 MB)
  static Future<File?> compressImage(
    File imageFile, {
    int maxSizeInKB = 2048,
    int quality = 85,
  }) async {
    try {
      // Get file size in KB
      int fileSizeInKB = await imageFile.length() ~/ 1024;

      // If file is already within limit, return original
      if (fileSizeInKB <= maxSizeInKB) {
        return imageFile;
      }

      // Read image file
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        debugPrint('Failed to decode image');
        return null;
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Try compression with initial quality
      File? compressedFile = await _compressWithQuality(
        image,
        targetPath,
        quality,
      );

      if (compressedFile == null) {
        return null;
      }

      // Check if compressed file is still too large
      int compressedSizeInKB = await compressedFile.length() ~/ 1024;

      // If still too large, try with lower quality
      if (compressedSizeInKB > maxSizeInKB) {
        // Calculate new quality based on size ratio
        int newQuality = ((quality * maxSizeInKB / compressedSizeInKB) * 0.9).round();
        newQuality = newQuality.clamp(20, quality); // Don't go below 20% quality

        compressedFile = await _compressWithQuality(
          image,
          targetPath,
          newQuality,
        );

        if (compressedFile == null) {
          return null;
        }

        // Final check
        compressedSizeInKB = await compressedFile.length() ~/ 1024;

        // If still too large, reduce dimensions
        if (compressedSizeInKB > maxSizeInKB) {
          compressedFile = await _compressWithDimensions(
            image,
            targetPath,
            maxSizeInKB,
          );
        }
      }

      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  /// Compress image with specific quality
  static Future<File?> _compressWithQuality(
    img.Image image,
    String targetPath,
    int quality,
  ) async {
    try {
      // Encode as JPEG with specified quality
      final compressedBytes = img.encodeJpg(image, quality: quality);

      // Write to file
      final file = File(targetPath);
      await file.writeAsBytes(compressedBytes);

      return file;
    } catch (e) {
      debugPrint('Error in _compressWithQuality: $e');
      return null;
    }
  }

  /// Compress image by reducing dimensions
  static Future<File?> _compressWithDimensions(
    img.Image image,
    String targetPath,
    int maxSizeInKB,
  ) async {
    try {
      // Start with 1920 max dimension and reduce if needed
      int maxDimension = 1920;
      int quality = 70;

      img.Image resized = _resizeImage(image, maxDimension);
      List<int> compressedBytes = img.encodeJpg(resized, quality: quality);
      int compressedSizeInKB = compressedBytes.length ~/ 1024;

      // If still too large, try smaller dimensions
      if (compressedSizeInKB > maxSizeInKB) {
        maxDimension = 1280;
        quality = 60;
        resized = _resizeImage(image, maxDimension);
        compressedBytes = img.encodeJpg(resized, quality: quality);
        compressedSizeInKB = compressedBytes.length ~/ 1024;

        // Try even smaller if still too large
        if (compressedSizeInKB > maxSizeInKB) {
          maxDimension = 800;
          quality = 50;
          resized = _resizeImage(image, maxDimension);
          compressedBytes = img.encodeJpg(resized, quality: quality);
        }
      }

      // Write to file
      final file = File(targetPath);
      await file.writeAsBytes(compressedBytes);

      return file;
    } catch (e) {
      debugPrint('Error in _compressWithDimensions: $e');
      return null;
    }
  }

  /// Resize image maintaining aspect ratio
  static img.Image _resizeImage(img.Image image, int maxDimension) {
    if (image.width <= maxDimension && image.height <= maxDimension) {
      return image;
    }

    int newWidth, newHeight;
    if (image.width > image.height) {
      newWidth = maxDimension;
      newHeight = (image.height * maxDimension / image.width).round();
    } else {
      newHeight = maxDimension;
      newWidth = (image.width * maxDimension / image.height).round();
    }

    return img.copyResize(image, width: newWidth, height: newHeight);
  }

  /// Get human-readable file size
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}
