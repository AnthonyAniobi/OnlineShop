import 'package:file_picker/file_picker.dart';
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

  Future<void> updateUserData(
      {String? email, String? password, String? name}) async {
    final loggedInState = state as LoggedInState;
    state = loggedInState.copy(status: RequestStatus.loading);

    final response = await authRepository.updateUser(
      id: loggedInState.user!.id,
      data: {
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (name != null) 'name': name,
      },
    );

    // call login request
    state = await response.fold(
      (failure) =>
          loggedInState.copy(status: RequestStatus.failed, error: failure),
      (user) async {
        /// user data is not gotten yet
        return loggedInState.copy(status: RequestStatus.success, user: user);
      },
    );
  }

  Future<void> updateUserImage({required PlatformFile file}) async {
    final loggedInState = state as LoggedInState;
    state = loggedInState.copy(status: RequestStatus.loading);

    final response = await authRepository.uploadFile(file: file);
    String? url;

    // call login request
    state = await response.fold(
      (failure) =>
          loggedInState.copy(status: RequestStatus.failed, error: failure),
      (imageUrl) async {
        /// user data is not gotten yet
        url = imageUrl;
        return loggedInState;
      },
    );

    // if image is uploaded send image url to the path
    if (url != null) {
      final profileResponse =
          await authRepository.updateUser(id: loggedInState.user!.id, data: {
        'avatar': url,
      });
      state = await profileResponse.fold(
        (error) =>
            loggedInState.copy(status: RequestStatus.failed, error: error),
        (user) => loggedInState.copy(user: user, status: RequestStatus.success),
      );
    }
  }
}
