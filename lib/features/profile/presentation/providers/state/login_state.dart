import 'package:equatable/equatable.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';
import 'package:online_shop/shared/domain/models/models.dart';
import 'package:online_shop/shared/enums/request_status.dart';

abstract class LoginAuthState extends Equatable {
  final RequestStatus status;

  const LoginAuthState({this.status = RequestStatus.initial});

  @override
  List<Object?> get props => [status];
}

class LoggedInState extends LoginAuthState {
  const LoggedInState({this.user, this.error, super.status});
  final User? user;
  final AppError? error;
}

class LoggedOutState extends LoginAuthState {
  const LoggedOutState({super.status, this.error});
  final AppError? error;
}
