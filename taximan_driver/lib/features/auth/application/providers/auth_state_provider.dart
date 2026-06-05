import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

class AuthState {
  const AuthState({
    this.userId,
    this.role = 'driver',
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final String? userId;
  final String role;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({
    String? userId,
    String? role,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository)
    : super(
        AuthState(
          userId: _repository.currentUser?.uid,
          isAuthenticated: _repository.currentUser != null,
        ),
      ) {
    _authSubscription = _repository.authStateChanges().listen(_setFirebaseUser);
  }

  final AuthRepository _repository;
  late final StreamSubscription<firebase_auth.User?> _authSubscription;

  void _setFirebaseUser(firebase_auth.User? user) {
    state = AuthState(userId: user?.uid, isAuthenticated: user != null);
  }

  Future<void> registerDriver({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.registerDriver(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      state = AuthState(userId: user.uid, isAuthenticated: true);
    } on firebase_auth.FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyAuthMessage(e),
      );
      rethrow;
    } on DriverEmailBelongsToPassengerException {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'That email belongs to a passenger account. Use a different driver email.',
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(
        emailOrPhone: email,
        password: password,
      );
      state = AuthState(userId: user.uid, isAuthenticated: true);
    } on firebase_auth.FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyAuthMessage(e),
      );
      rethrow;
    } on DriverAccountMissingException {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'This account is not registered as a driver. Use a driver email or phone number.',
      );
      rethrow;
    } on DriverEmailBelongsToPassengerException {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'That email belongs to a passenger account. Use a different driver email.',
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

String _friendlyAuthMessage(firebase_auth.FirebaseAuthException exception) {
  return switch (exception.code) {
    'invalid-email' => 'Enter a valid email address.',
    'user-disabled' => 'This account has been disabled.',
    'user-not-found' => 'Account does not exist.',
    'wrong-password' => 'Password is incorrect.',
    'invalid-credential' => 'Email or password is incorrect.',
    'email-already-in-use' => 'An account already exists for this email.',
    'weak-password' => 'Use a stronger password.',
    'network-request-failed' => 'Check your internet connection and try again.',
    _ => exception.message ?? 'Authentication failed. Please try again.',
  };
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);
