import 'package:online_shop/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:online_shop/shared/data/local/local_token_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/shared/enums/request_status.dart';

class LoginNotifier extends StateNotifier<LoginAuthState> {
  final AuthenticationRepository authRepository;

  LoginNotifier({
    required this.authRepository,
  }) : super(const LoggedOutState());

  Future<void> loginUser(String email, String password) async {
    state = const LoggedOutState(status: RequestStatus.loading);
    final response = await authRepository.loginUser(
      email: email,
      password: password,
    );

    // call login request
    state = await response.fold(
      (failure) => LoggedOutState(status: RequestStatus.failed, error: failure),
      (token) async {
        /// save token to local storage and signin
        LocalTokenStorage.updateToken(token);

        /// user data is not gotten yet
        return const LoggedInState(status: RequestStatus.success);
      },
    );

    // if user is logged in, fetch user information
    if (state is LoggedInState) {
      final profileResponse = await authRepository.getUser();
      state = await profileResponse.fold(
          (error) => LoggedInState(status: RequestStatus.failed, error: error),
          (user) => LoggedInState(user: user, status: RequestStatus.success));
    }
  }

  Future<void> logout() async {
    await LocalTokenStorage.reset();
    state = const LoggedOutState();
  }
}
