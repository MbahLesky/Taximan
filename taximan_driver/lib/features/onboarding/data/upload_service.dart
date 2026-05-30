import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  UploadService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static const int maxFileSizeBytes = 1024 * 1024;

  Future<String> uploadDriverDocument({
    required String driverId,
    required String documentType,
    required PlatformFile file,
  }) async {
    if (file.size > maxFileSizeBytes) {
      throw const FileSizeLimitException();
    }

    final bytes = file.bytes;
    if (bytes == null) {
      throw Exception('Could not read the selected file.');
    }

    if (bytes.lengthInBytes > maxFileSizeBytes) {
      throw const FileSizeLimitException();
    }

    final extension = file.extension == null ? '' : '.${file.extension}';
    final storageName = '${DateTime.now().millisecondsSinceEpoch}$extension';
    final ref = _storage
        .ref()
        .child('driver_documents')
        .child(driverId)
        .child(documentType)
        .child(storageName);

    final task = await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(file.extension)),
    );
    return task.ref.getDownloadURL();
  }
}

class FileSizeLimitException implements Exception {
  const FileSizeLimitException();

  @override
  String toString() => 'Files must be 1 MB or smaller.';
}

String _contentType(String? extension) {
  return switch (extension?.toLowerCase()) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'pdf' => 'application/pdf',
    _ => 'application/octet-stream',
  };
}
