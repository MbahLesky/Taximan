import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/upload_service.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService();
});
