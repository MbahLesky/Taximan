import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/user.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'users';

  Future<User?> getUser(String userId) async {
    final doc = await _firestore.collection(_collection).doc(userId).get();
    if (!doc.exists) {
      return null;
    }
    return User.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(
    String userId, {
    String? fullName,
    String? phone,
  }) async {
    final updateData = <String, dynamic>{};
    if (fullName != null) {
      updateData['fullName'] = fullName.trim();
    }
    if (phone != null) {
      updateData['phone'] = phone.trim();
    }
    if (updateData.isEmpty) {
      return;
    }
    updateData['updatedAt'] = DateTime.now();

    await _firestore.collection(_collection).doc(userId).update(updateData);
  }

  Stream<User?> streamUser(String userId) {
    return _firestore.collection(_collection).doc(userId).snapshots().map((
      doc,
    ) {
      if (!doc.exists) {
        return null;
      }
      return User.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateUser(
    String userId, {
    String? fullName,
    String? phone,
    String? email,
  }) async {
    final updateData = <String, dynamic>{'updatedAt': DateTime.now()};

    if (fullName != null && fullName.trim().isNotEmpty) {
      updateData['fullName'] = fullName.trim();
    }
    if (phone != null && phone.trim().isNotEmpty) {
      updateData['phone'] = phone.trim();
    }
    if (email != null && email.trim().isNotEmpty) {
      updateData['email'] = email.trim();
    }

    if (updateData.length > 1) {
      await _firestore.collection(_collection).doc(userId).update(updateData);
    }
  }
}
