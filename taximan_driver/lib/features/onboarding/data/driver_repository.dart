import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/driver_model.dart';
import '../../../shared/models/vehicle.dart';

class DriverRepository {
  DriverRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<DriverModel?> streamDriver(String driverId) {
    return _firestore.collection('drivers').doc(driverId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return DriverModel.fromMap(data);
    });
  }

  Future<void> updatePersonalInfo({
    required String driverId,
    required String fullName,
    required String city,
  }) async {
    await _firestore.collection('drivers').doc(driverId).set({
      'id': driverId,
      'fullName': fullName.trim(),
      'city': city.trim(),
      'role': 'driver',
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
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    for (final entry in documentUrls.entries) {
      final documentRef = _firestore.collection('driver_documents').doc();
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
}
