import 'package:file_picker/file_picker.dart';
import 'package:online_shop/configs/app_data_types.dart';
import 'package:online_shop/shared/domain/models/models.dart';

abstract class AuthenticationRepository {
  AsyncApiErrorOr<String> loginUser(
      {required String email, required String password});
  AsyncApiErrorOr<User> registerUser({
    required String email,
    required String password,
    required String name,
    required String avatar,
  });
  AsyncApiErrorOr<User> getUser();
  AsyncApiErrorOr<User> updateUser(
      {required int id, required Map<String, dynamic> data});
  AsyncApiErrorOr<String> uploadFile({required PlatformFile file});
}
