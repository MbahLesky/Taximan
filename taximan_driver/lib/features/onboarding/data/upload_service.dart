import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  UploadService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static const int maxFileSizeBytes = 1024 * 1024;
  static const allowedDocumentExtensions = {'jpg', 'jpeg', 'png', 'pdf'};
  static const allowedImageExtensions = {'jpg', 'jpeg', 'png'};

  Future<String> uploadDriverDocument({
    required String driverId,
    required String documentType,
    required PlatformFile file,
  }) async {
    final extension = _validatedExtension(
      file,
      allowedExtensions: allowedDocumentExtensions,
    );
    final bytes = _validatedBytes(file);

    final storageName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final ref = _storage
        .ref()
        .child('driver_documents')
        .child(driverId)
        .child(documentType)
        .child(storageName);

    final task = await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(extension)),
    );
    return task.ref.getDownloadURL();
  }

  Future<String> uploadDriverProfilePhoto({
    required String driverId,
    required PlatformFile file,
  }) async {
    _validatedExtension(file, allowedExtensions: allowedImageExtensions);
    final bytes = _validatedBytes(file);
    final extension = file.extension?.toLowerCase() ?? 'jpg';
    final ref = _storage
        .ref()
        .child('driver_photos')
        .child(driverId)
        .child('profile.$extension');

    final task = await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(extension)),
    );
    return task.ref.getDownloadURL();
  }
}

class FileSizeLimitException implements Exception {
  const FileSizeLimitException();

  @override
  String toString() => 'Files must be 1 MB or smaller.';
}

class UnsupportedFileTypeException implements Exception {
  const UnsupportedFileTypeException(this.allowedExtensions);

  final Set<String> allowedExtensions;

  @override
  String toString() {
    final extensions = allowedExtensions.map((value) => value.toUpperCase());
    return 'Only ${extensions.join(', ')} files are supported.';
  }
}

String _validatedExtension(
  PlatformFile file, {
  required Set<String> allowedExtensions,
}) {
  final extension = file.extension?.toLowerCase();
  if (extension == null || !allowedExtensions.contains(extension)) {
    throw UnsupportedFileTypeException(allowedExtensions);
  }
  return extension;
}

Uint8List _validatedBytes(PlatformFile file) {
  if (file.size > UploadService.maxFileSizeBytes) {
    throw const FileSizeLimitException();
  }

  final bytes = file.bytes;
  if (bytes == null) {
    throw Exception('Could not read the selected file.');
  }

  if (bytes.lengthInBytes > UploadService.maxFileSizeBytes) {
    throw const FileSizeLimitException();
  }
  return bytes;
}

String _contentType(String? extension) {
  return switch (extension?.toLowerCase()) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'pdf' => 'application/pdf',
    _ => 'application/octet-stream',
  };
}
