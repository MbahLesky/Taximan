import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/driver.dart';

class DriverRepository {
  DriverRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'drivers';

  Future<Driver?> getDriver(String driverId) async {
    final doc = await _firestore.collection(_collection).doc(driverId).get();
    if (!doc.exists) {
      return null;
    }
    return Driver.fromMap(doc.data() as Map<String, dynamic>);
  }

  Stream<Driver?> streamDriver(String driverId) {
    return _firestore.collection(_collection).doc(driverId).snapshots().map(
      (doc) {
        if (!doc.exists) {
          return null;
        }
        return Driver.fromMap(doc.data() as Map<String, dynamic>);
      },
    );
  }

  Future<int> getAvailableDriverCount() async {
    final query = await _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .where('availabilityStatus', isEqualTo: 'online')
        .get();
    return query.docs.length;
  }

  Future<List<Driver>> getAvailableDrivers({int limit = 20}) async {
    final query = await _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .where('availabilityStatus', isEqualTo: 'online')
        .limit(limit)
        .get();
    return query.docs.map((doc) => Driver.fromMap(doc.data())).toList();
  }

  Stream<List<Driver>> streamAllDrivers({int limit = 100}) {
    return _firestore
        .collection(_collection)
        .limit(limit)
        .snapshots()
        .map((snapshot) {

          print("/n/n/nReceived driver snapshot with ${snapshot.docs.length} documents/n ${snapshot.docs} /n/n");

          return snapshot.docs
              .map((doc) => Driver.fromMap(doc.data()))
              .toList();
        });
  }
}
