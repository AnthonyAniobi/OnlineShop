import 'package:online_shop/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:online_shop/features/authentication/data/repositories/atuhentication_repository_impl.dart';
import 'package:online_shop/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_shop/shared/services/rest_service.dart';
import 'package:online_shop/shared/domain/providers/dio_network_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authdataSourceProvider = Provider.family<AuthUserDataSource, RestService>(
  (_, networkService) => AuthUserRemoteDataSource(networkService),
);

final authRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) {
    final RestService networkService = ref.watch(netwokServiceProvider);
    final AuthUserDataSource dataSource =
        ref.watch(authdataSourceProvider(networkService));
    return AuthenticationRepositoryImpl(dataSource);
  },
);
