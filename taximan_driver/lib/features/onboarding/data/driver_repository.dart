import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/driver_model.dart';
import '../../../shared/models/model_helpers.dart';
import '../../../shared/models/vehicle.dart';

class DriverRepository {
  DriverRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DriverModel?> fetchDriver(String driverId) async {
    final snapshot = await _firestore.collection('drivers').doc(driverId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return DriverModel.fromMap({...data, 'id': data['id'] ?? snapshot.id});
  }

  Stream<DriverModel?> streamDriver(String driverId) {
    return _firestore.collection('drivers').doc(driverId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return DriverModel.fromMap({...data, 'id': data['id'] ?? snapshot.id});
    });
  }

  Stream<List<DriverDocumentRecord>> streamDriverDocuments(String driverId) {
    return _firestore
        .collection('driver_documents')
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .map((snapshot) {
          final documents = snapshot.docs
              .map(
                (doc) => DriverDocumentRecord.fromMap({
                  ...doc.data(),
                  'id': doc.data()['id'] ?? doc.id,
                }),
              )
              .toList();
          documents.sort((a, b) => a.documentType.compareTo(b.documentType));
          return documents;
        });
  }

  Future<void> updatePersonalInfo({
    required String driverId,
    required String city,
  }) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'id': driverId,
      'city': city.trim(),
      'role': 'driver',
      'onboardingStatus': 'vehicle_details',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateDriverProfile({
    required String driverId,
    required String fullName,
    required String phone,
    required String city,
  }) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'id': driverId,
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'city': city.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> saveVehicle({
    required String driverId,
    required Vehicle vehicle,
  }) async {
    final vehicleRef = _firestore.collection('vehicles').doc();
    final vehicleId = vehicleRef.id;
    final vehicleData = {
      'id': vehicleId,
      'driverId': driverId,
      'vehicleType': vehicle.type.trim().toLowerCase(),
      'type': vehicle.type.trim(),
      'model': vehicle.model.trim(),
      'plateNumber': vehicle.plateNumber.trim(),
      'color': vehicle.color.trim(),
      'capacity': vehicle.capacity,
      'documentStatus': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore.runTransaction((transaction) async {
      transaction.set(vehicleRef, vehicleData);
      transaction.set(_firestore.collection('drivers').doc(driverId), {
        'id': driverId,
        'vehicleId': vehicleId,
        'vehicle': vehicle.toMap(),
        'onboardingStatus': 'documents',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    return vehicleId;
  }

  Future<void> saveDocumentUrls({
    required String driverId,
    required Map<String, String> documentUrls,
  }) async {
    final driverRef = _firestore.collection('drivers').doc(driverId);
    final batch = _firestore.batch();

    batch.set(driverRef, {
      'documentUrls': documentUrls,
      'verificationStatus': 'pending',
      'onboardingStatus': 'profile_photo',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    for (final entry in documentUrls.entries) {
      final documentRef = _firestore
          .collection('driver_documents')
          .doc('${driverId}_${entry.key}');
      batch.set(documentRef, {
        'id': documentRef.id,
        'driverId': driverId,
        'documentType': entry.key,
        'fileUrl': entry.value,
        'status': 'pending',
        'rejectionReason': null,
        'uploadedAt': FieldValue.serverTimestamp(),
        'reviewedAt': null,
      });
    }

    await batch.commit();
  }

  Future<void> saveProfilePhotoUrl({
    required String driverId,
    required String profilePhotoUrl,
  }) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'profilePhotoUrl': profilePhotoUrl,
      'verificationStatus': 'pending',
      'onboardingStatus': 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> markPlatformFeePaidToday(String driverId) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'platformFeePaidAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

class DriverDocumentRecord {
  const DriverDocumentRecord({
    required this.id,
    required this.driverId,
    required this.documentType,
    required this.fileUrl,
    required this.status,
    this.rejectionReason,
    this.uploadedAt,
    this.reviewedAt,
  });

  final String id;
  final String driverId;
  final String documentType;
  final String fileUrl;
  final String status;
  final String? rejectionReason;
  final DateTime? uploadedAt;
  final DateTime? reviewedAt;

  factory DriverDocumentRecord.fromMap(Map<String, dynamic> map) {
    return DriverDocumentRecord(
      id: map['id'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      documentType: map['documentType'] as String? ?? '',
      fileUrl: map['fileUrl'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      rejectionReason: map['rejectionReason'] as String?,
      uploadedAt: readDateTime(map['uploadedAt']),
      reviewedAt: readDateTime(map['reviewedAt']),
    );
  }
}
