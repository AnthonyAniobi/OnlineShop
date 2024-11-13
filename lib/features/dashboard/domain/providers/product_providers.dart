import 'package:online_shop/features/dashboard/data/datasource/product_remote_datasource.dart';
import 'package:online_shop/features/dashboard/data/repositories/product_repository.dart';
import 'package:online_shop/features/dashboard/domain/repositories/product_repository.dart';
import 'package:online_shop/shared/services/rest_service.dart';
import 'package:online_shop/shared/domain/providers/dio_network_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDatasourceProvider =
    Provider.family<ProductDatasource, RestService>(
  (_, networkService) => ProductRemoteDatasource(networkService),
);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final networkService = ref.watch(netwokServiceProvider);
  final datasource = ref.watch(productDatasourceProvider(networkService));
  final respository = ProductRepositoryImpl(datasource);

  return respository;
});
