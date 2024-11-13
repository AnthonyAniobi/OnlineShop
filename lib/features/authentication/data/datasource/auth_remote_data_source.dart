import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:online_shop/shared/services/rest_service.dart';
import 'package:online_shop/shared/domain/models/models.dart';

abstract class AuthUserDataSource {
  Future<String> loginUser({required String email, required String password});
  Future<User> registerUser({
    required String email,
    required String password,
    required String name,
    required String avatar,
  });
  Future<User> getUser();
  Future<User> updateUser(
      {required int id, required Map<String, dynamic> data});
  Future<String> uploadFile({required PlatformFile file});
}

class AuthUserRemoteDataSource implements AuthUserDataSource {
  final RestService networkService;

  AuthUserRemoteDataSource(this.networkService);

  @override
  Future<String> loginUser(
      {required String email, required String password}) async {
    final response = await networkService.post(
      path: '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.hasError) throw response.error;
    return response.data!['access_token'];
  }

  @override
  Future<User> registerUser({
    required String email,
    required String password,
    required String name,
    required String avatar,
  }) async {
    final response = await networkService.post(
      path: '/users/',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'avatar': avatar,
      },
    );
    if (response.hasError) throw response.error;

    return User.fromJson(response.data!);
  }

  @override
  Future<User> getUser() async {
    final response = await networkService.get(
      path: '/auth/profile',
    );
    if (response.hasError) throw response.error;

    return User.fromJson(response.data!);
  }

  @override
  Future<User> updateUser(
      {required int id, required Map<String, dynamic> data}) async {
    final response = await networkService.put(
      path: '/users/$id',
      data: data,
    );
    if (response.hasError) throw response.error;

    return User.fromJson(response.data!);
  }

  @override
  Future<String> uploadFile({required PlatformFile file}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromFileSync(file.path!, filename: file.name),
    });

    final response = await networkService.postFormData(
      path: '/files/upload',
      data: formData,
    );

    if (response.hasError) throw response.error;
    return response.data!['location'];
  }
}
