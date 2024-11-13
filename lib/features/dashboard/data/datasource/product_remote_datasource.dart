import 'package:online_shop/shared/services/rest_service.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';

abstract class ProductDatasource {
  Future<List<Product>> fetchProducts();
  Future<List<Product>> searchPaginatedProducts({required String query});
}

class ProductRemoteDatasource extends ProductDatasource {
  final RestService networkService;
  ProductRemoteDatasource(this.networkService);

  @override
  Future<List<Product>> fetchProducts() async {
    final response = await networkService.get(
      path: '/products',
    );
    if (response.hasError) {
      throw response.error;
    }
    final listResponse =
        List<Map<String, dynamic>>.from(response.data!['data'] as List);
    return listResponse.map((prod) => Product.fromJson(prod)).toList();
  }

  @override
  Future<List<Product>> searchPaginatedProducts({required String query}) async {
    final response = await networkService.get(
      path: '/products',
      params: {
        'title': query,
      },
    );

    if (response.hasError) {
      throw response.error;
    }

    final listResponse = List<Map<String, dynamic>>.from(response.data as List);
    return listResponse.map((prod) => Product.fromJson(prod)).toList();
  }
}
