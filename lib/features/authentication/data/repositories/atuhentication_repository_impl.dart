import 'package:dartz/dartz.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:online_shop/configs/app_data_types.dart';
import 'package:online_shop/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:online_shop/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';
import 'package:online_shop/shared/domain/models/user_model.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthUserDataSource datasource;

  AuthenticationRepositoryImpl(this.datasource);

  @override
  AsyncApiErrorOr<User> getUser() async {
    try {
      final result = await datasource.getUser();
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }

  @override
  AsyncApiErrorOr<String> loginUser(
      {required String email, required String password}) async {
    try {
      final result =
          await datasource.loginUser(email: email, password: password);
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }

  @override
  AsyncApiErrorOr<User> registerUser({
    required String email,
    required String password,
    required String name,
    required String avatar,
  }) async {
    try {
      final result = await datasource.registerUser(
        email: email,
        password: password,
        avatar: avatar,
        name: name,
      );
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }

  @override
  AsyncApiErrorOr<User> updateUser(
      {required int id, required Map<String, dynamic> data}) async {
    try {
      final result = await datasource.updateUser(id: id, data: data);
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }

  @override
  AsyncApiErrorOr<String> uploadFile({required PlatformFile file}) async {
    try {
      final result = await datasource.uploadFile(file: file);
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }
}
