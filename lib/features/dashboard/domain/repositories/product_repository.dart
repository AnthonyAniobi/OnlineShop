import 'package:online_shop/configs/app_data_types.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';

abstract class ProductRepository {
  AsyncApiErrorOr<List<Product>> fetchProducts();
  AsyncApiErrorOr<List<Product>> searchProducts({required String query});
}
