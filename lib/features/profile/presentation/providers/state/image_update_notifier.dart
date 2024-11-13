import 'package:file_picker/file_picker.dart';
import 'package:online_shop/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/signup_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/shared/enums/request_status.dart';

class ImageUpdateNotifier extends StateNotifier<SignupState> {
  final AuthenticationRepository authRepository;

  ImageUpdateNotifier({
    required this.authRepository,
  }) : super(const UploadingImageState(status: RequestStatus.initial));

  Future<void> createAccount(
    String email,
    String password,
    String name,
    PlatformFile file,
  ) async {
    state = const UploadingImageState(status: RequestStatus.loading);

    final response = await authRepository.uploadFile(file: file);

    // call login request
    state = await response.fold(
      (failure) =>
          UploadingImageState(status: RequestStatus.failed, error: failure),
      (imageUrl) async {
        /// user data is not gotten yet
        return UploadingDataState(
            imageUrl: imageUrl, status: RequestStatus.initial);
      },
    );

    // if image is uploaded send other user data
    if (state is UploadingDataState) {
      final uploadState = state as UploadingDataState;
      final profileResponse = await authRepository.registerUser(
        email: email,
        password: password,
        name: name,
        avatar: uploadState.imageUrl,
      );
      state = await profileResponse.fold(
          (error) => UploadingDataState(
              imageUrl: uploadState.imageUrl,
              status: RequestStatus.failed,
              error: error),
          (user) =>
              AccountCreatedState(user: user, status: RequestStatus.success));
    }
  }
}
