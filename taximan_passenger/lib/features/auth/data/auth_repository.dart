import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../shared/models/user.dart';

class AuthRepository {
  AuthRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  firebase_auth.User? get currentUser => _auth.currentUser;

  Stream<firebase_auth.User?> authStateChanges() => _auth.authStateChanges();

  Future<firebase_auth.User> registerPassenger({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Could not create passenger account.');
    }

    await firebaseUser.updateDisplayName(fullName.trim());

    final passenger = User(
      id: firebaseUser.uid,
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      homeLocation: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(firebaseUser.uid).set(
          passenger.toMap(),
        );

    return firebaseUser;
  }

  Future<firebase_auth.User> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Could not sign in.');
    }
    return firebaseUser;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> logout() => _auth.signOut();
}
