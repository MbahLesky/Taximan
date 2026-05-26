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

  Stream<User?> streamUser(String userId) {
    return _firestore.collection(_collection).doc(userId).snapshots().map(
      (doc) {
        if (!doc.exists) {
          return null;
        }
        return User.fromMap(doc.data() as Map<String, dynamic>);
      },
    );
  }
}
