import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/user.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../data/user_repository.dart';

class UserState {
  const UserState({
    required this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final User user;
  final bool isLoading;
  final String? errorMessage;

  UserState copyWith({User? user, bool? isLoading, String? errorMessage}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class UserController extends StateNotifier<UserState> {
  UserController()
    : super(
        const UserState(
          user: User(
            id: '',
            fullName: '',
            email: '',
            phone: '',
            homeLocation: '',
          ),
        ),
      );

  void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? homeLocation,
    String? profilePhotoUrl,
  }) {
    state = state.copyWith(
      user: state.user.copyWith(
        fullName: fullName,
        email: email,
        phone: phone,
        homeLocation: homeLocation,
        profilePhotoUrl: profilePhotoUrl,
        updatedAt: DateTime.now(),
      ),
      errorMessage: null,
    );
  }

  void setDefaultPaymentMethod(String method) {
    state = state.copyWith(
      user: state.user.copyWith(
        defaultPaymentMethod: method,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}

final userStateProvider = StateNotifierProvider<UserController, UserState>(
  (ref) => UserController(),
);

final userProvider = Provider<User>((ref) => ref.watch(userStateProvider).user);

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserProvider = StreamProvider<User?>((ref) {
  final userId = ref.watch(authStateProvider).userId;
  if (userId == null || userId.isEmpty) {
    return const Stream<User?>.empty();
  }
  return ref.watch(userRepositoryProvider).streamUser(userId);
});
