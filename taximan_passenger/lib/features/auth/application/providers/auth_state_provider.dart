import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({
    this.userId,
    this.role = 'passenger',
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
  AuthController()
    : super(const AuthState(userId: 'passenger-001', isAuthenticated: true));

  void login(String userId) {
    state = state.copyWith(
      userId: userId,
      isAuthenticated: true,
      isLoading: false,
      errorMessage: null,
    );
  }

  void logout() {
    state = const AuthState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}

final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
