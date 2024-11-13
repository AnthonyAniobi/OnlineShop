import 'package:dartz/dartz.dart';
import 'package:online_shop/configs/app_data_types.dart';
import 'package:online_shop/features/dashboard/data/datasource/product_remote_datasource.dart';
import 'package:online_shop/features/dashboard/domain/repositories/product_repository.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductDatasource datasource;
  ProductRepositoryImpl(this.datasource);

  @override
  AsyncApiErrorOr<List<Product>> fetchProducts() async {
    try {
      final result = await datasource.fetchProducts();
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }

  @override
  AsyncApiErrorOr<List<Product>> searchProducts({required String query}) async {
    try {
      final result = await datasource.searchPaginatedProducts(query: query);
      return Right(result);
    } on ApiError catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ApiError.unknown);
    }
  }
}
