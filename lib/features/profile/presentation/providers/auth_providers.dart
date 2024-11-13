import 'package:online_shop/features/authentication/domain/providers/auth_provider.dart';
import 'package:online_shop/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_notifier.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/signup_notifier.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/signup_state.dart';

final loginStateNotifierProvider =
    StateNotifierProvider<LoginNotifier, LoginAuthState>(
  (ref) {
    final AuthenticationRepository authenticationRepository =
        ref.watch(authRepositoryProvider);
    return LoginNotifier(
      authRepository: authenticationRepository,
    );
  },
);

final signupStateNotifierProvider =
    StateNotifierProvider<SignupNotifier, SignupState>(
  (ref) {
    final AuthenticationRepository authenticationRepository =
        ref.watch(authRepositoryProvider);
    return SignupNotifier(
      authRepository: authenticationRepository,
    );
  },
);
