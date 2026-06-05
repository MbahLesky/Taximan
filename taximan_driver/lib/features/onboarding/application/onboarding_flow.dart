import '../../../shared/models/driver_model.dart';
import '../domain/driver_document_requirements.dart';

String nextDriverRoute(DriverModel driver) {
  if (driver.fullName.trim().isEmpty || driver.city.trim().isEmpty) {
    return '/driver-personal-info';
  }
  if (driver.vehicleId == null ||
      driver.vehicleId!.trim().isEmpty ||
      driver.vehicle == null) {
    return '/vehicle-details';
  }
  if (!_hasAllRequiredDocuments(driver.documentUrls)) {
    return '/document-upload';
  }
  if (driver.profilePhotoUrl == null || driver.profilePhotoUrl!.isEmpty) {
    return '/profile-photo';
  }

  return switch (driver.verificationStatus.toLowerCase()) {
    'approved' => '/dashboard',
    'rejected' || 'suspended' => '/verification-rejected',
    _ => '/verification-pending',
  };
}

bool _hasAllRequiredDocuments(Map<String, String> documentUrls) {
  return requiredDriverDocuments.every((document) {
    final url = documentUrls[document.type];
    return url != null && url.trim().isNotEmpty;
  });
}
