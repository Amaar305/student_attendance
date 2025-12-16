// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Enum defining all supported media types
enum MediaType {
  image,
  images,
  video,
  videos,
  audio,
  audios,
  file,
  files,
  camera,
}

/// Data class to hold media picking results
class MediaPickerResult {
  // For any additional data

  MediaPickerResult({
    required this.files,
    required this.mediaType,
    this.paths,
    this.extra,
  });
  final List<File> files;
  final List<String>? paths;
  final MediaType mediaType;
  final dynamic extra;

  /// Convenience getter for single file
  File? get file => files.isNotEmpty ? files.first : null;

  /// Convenience getter for single path
  String? get path => paths?.isNotEmpty ?? false ? paths?.first : null;
}

/// Helper class for picking media files with clean and extensible architecture
class MediaPickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();
  static final FilePicker _filePicker = FilePicker.platform;

  /// Main method to pick media files
  ///
  /// [mediaType]: Type of media to pick
  /// [allowMultiple]: Whether to allow multiple selections (where applicable)
  /// [withData]: Whether to load file data
  ///  immediately (memory intensive for large files)
  /// [allowedExtensions]: List of allowed file extensions (for file picking)
  /// [cameraDevice]: Preferred camera device (front/back)
  ///
  /// Returns [MediaPickerResult] containing the selected files
  static Future<MediaPickerResult?> pickMedia({
    required MediaType mediaType,
    bool allowMultiple = false,
    bool withData = true,
    List<String>? allowedExtensions,
    CameraDevice cameraDevice = CameraDevice.rear,
  }) async {
    try {
      switch (mediaType) {
        case MediaType.image:
          return await _pickImage(
            cameraDevice: cameraDevice,
          );
        case MediaType.images:
          return await _pickImage(allowMultiple: true);
        case MediaType.video:
          return await _pickVideo(
            cameraDevice: cameraDevice,
          );
        case MediaType.videos:
          return await _pickVideo(allowMultiple: true);
        case MediaType.audio:
        case MediaType.audios:
          return await _pickAudio(allowMultiple: mediaType == MediaType.audios);
        case MediaType.file:
          return await _pickFile(
            withData: withData,
            allowedExtensions: allowedExtensions,
          );
        case MediaType.files:
          return await _pickFile(
            allowMultiple: true,
            withData: withData,
            allowedExtensions: allowedExtensions,
          );
        case MediaType.camera:
          return await _pickFromCamera(cameraDevice: cameraDevice);
      }
    } catch (e, stackTrace) {
      debugPrint('MediaPicker Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      return null;
    }
  }

  // --- Private methods for specific media types ---

  static Future<MediaPickerResult?> _pickImage({
    bool allowMultiple = false,
    CameraDevice cameraDevice = CameraDevice.rear,
  }) async {
    if (allowMultiple) {
      // For multiple images, we use the file
      //picker on web and image picker on mobile
      if (kIsWeb) {
        final result = await _filePicker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );
        if (result == null) return null;
        return MediaPickerResult(
          files: result.paths.map((path) => File(path!)).toList(),
          paths: result.paths.map((path) => path!).toList(),
          mediaType: MediaType.images,
        );
      } else {
        final pickedFiles = await _imagePicker.pickMultiImage();
        if (pickedFiles.isEmpty) return null;
        return MediaPickerResult(
          files: pickedFiles.map((file) => File(file.path)).toList(),
          paths: pickedFiles.map((file) => file.path).toList(),
          mediaType: MediaType.images,
        );
      }
    } else {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        preferredCameraDevice: cameraDevice,
      );
      if (pickedFile == null) return null;
      return MediaPickerResult(
        files: [File(pickedFile.path)],
        paths: [pickedFile.path],
        mediaType: MediaType.image,
      );
    }
  }

  static Future<MediaPickerResult?> _pickVideo({
    bool allowMultiple = false,
    CameraDevice cameraDevice = CameraDevice.rear,
  }) async {
    if (allowMultiple) {
      if (kIsWeb) {
        final result = await _filePicker.pickFiles(
          type: FileType.video,
          allowMultiple: true,
        );
        if (result == null) return null;
        return MediaPickerResult(
          files: result.paths.map((path) => File(path!)).toList(),
          paths: result.paths.map((path) => path!).toList(),
          mediaType: MediaType.videos,
        );
      } else {
        // On mobile, we might need to use a different
        // approach for multiple videos
        // as image_picker doesn't support multiple video selection directly
        final pickedFile = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
          preferredCameraDevice: cameraDevice,
        );
        if (pickedFile == null) return null;
        return MediaPickerResult(
          files: [File(pickedFile.path)],
          paths: [pickedFile.path],
          mediaType: MediaType.video,
        );
      }
    } else {
      final pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        preferredCameraDevice: cameraDevice,
      );
      if (pickedFile == null) return null;
      return MediaPickerResult(
        files: [File(pickedFile.path)],
        paths: [pickedFile.path],
        mediaType: MediaType.video,
      );
    }
  }

  static Future<MediaPickerResult?> _pickAudio({
    bool allowMultiple = false,
  }) async {
    final result = await _filePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: allowMultiple,
    );
    if (result == null) return null;
    return MediaPickerResult(
      files: result.paths.map((path) => File(path!)).toList(),
      paths: result.paths.map((path) => path!).toList(),
      mediaType: allowMultiple ? MediaType.audios : MediaType.audio,
    );
  }

  static Future<MediaPickerResult?> _pickFile({
    bool allowMultiple = false,
    bool withData = true,
    List<String>? allowedExtensions,
  }) async {
    final result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
      withData: withData,
    );
    if (result == null) return null;
    return MediaPickerResult(
      files: result.paths.map((path) => File(path!)).toList(),
      paths: result.paths.map((path) => path!).toList(),
      mediaType: allowMultiple ? MediaType.files : MediaType.file,
      extra: allowedExtensions,
    );
  }

  static Future<MediaPickerResult?> _pickFromCamera({
    CameraDevice cameraDevice = CameraDevice.rear,
  }) async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: cameraDevice,
    );
    if (pickedFile == null) return null;
    return MediaPickerResult(
      files: [File(pickedFile.path)],
      paths: [pickedFile.path],
      mediaType: MediaType.image,
    );
  }

  // --- Utility Methods ---

  /// Checks if a file type is supported by the media picker
  static bool isSupportedMediaType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    const supportedExtensions = {
      'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
      'mp4', 'mov', 'avi', 'mkv', 'flv', // Videos
      'mp3', 'wav', 'ogg', 'aac', 'm4a', // Audio
      'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', // Documents
    };
    return supportedExtensions.contains(extension);
  }

  /// Gets the media type from a file extension
  static MediaType? getMediaTypeFromExtension(String extension) {
    final ext = extension.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      return MediaType.image;
    } else if (['mp4', 'mov', 'avi', 'mkv', 'flv'].contains(ext)) {
      return MediaType.video;
    } else if (['mp3', 'wav', 'ogg', 'aac', 'm4a'].contains(ext)) {
      return MediaType.audio;
    } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt']
        .contains(ext)) {
      return MediaType.file;
    }
    return null;
  }
}
