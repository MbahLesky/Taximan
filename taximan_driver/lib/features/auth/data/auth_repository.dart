import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../shared/models/driver_model.dart';

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

  Future<firebase_auth.User> registerDriver({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    await _assertEmailIsAvailableForDriver(normalizedEmail);

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Could not create driver account.');
    }

    await firebaseUser.updateDisplayName(fullName.trim());

    final driver = DriverModel(
      id: firebaseUser.uid,
      fullName: fullName.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      verificationStatus: 'not_submitted',
      onboardingStatus: 'personal_info',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('drivers').doc(firebaseUser.uid).set({
      ...driver.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return firebaseUser;
  }

  Future<firebase_auth.User> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final email = await _resolveDriverEmail(emailOrPhone);
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Could not sign in.');
    }

    final driverSnapshot = await _firestore
        .collection('drivers')
        .doc(firebaseUser.uid)
        .get();
    final driverData = driverSnapshot.data();
    if (driverData == null || driverData['role'] != 'driver') {
      await _auth.signOut();
      throw const DriverAccountMissingException();
    }

    return firebaseUser;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> logout() => _auth.signOut();

  Future<void> _assertEmailIsAvailableForDriver(String normalizedEmail) async {
    final passengerSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();
    if (passengerSnapshot.docs.isNotEmpty) {
      throw const DriverEmailBelongsToPassengerException();
    }
  }

  Future<String> _resolveDriverEmail(String emailOrPhone) async {
    final identifier = emailOrPhone.trim();
    if (identifier.contains('@')) {
      return identifier.toLowerCase();
    }

    final driverSnapshot = await _firestore
        .collection('drivers')
        .where('phone', isEqualTo: identifier)
        .limit(1)
        .get();
    if (driverSnapshot.docs.isEmpty) {
      throw const DriverAccountMissingException();
    }

    final email = driverSnapshot.docs.first.data()['email'] as String?;
    if (email == null || email.trim().isEmpty) {
      throw const DriverAccountMissingException();
    }
    return email.trim().toLowerCase();
  }
}

class DriverAccountMissingException implements Exception {
  const DriverAccountMissingException();

  @override
  String toString() => 'No driver account was found for these credentials.';
}

class DriverEmailBelongsToPassengerException implements Exception {
  const DriverEmailBelongsToPassengerException();

  @override
  String toString() => 'Use a different email for your driver account.';
}
