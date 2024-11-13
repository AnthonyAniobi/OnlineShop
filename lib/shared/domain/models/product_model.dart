import 'package:online_shop/shared/domain/models/category_model.dart';

typedef ProductList = List<Product>;

class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    num price = json[_priceKey];
    return Product(
      id: json[_idKey],
      title: json[_titleKey],
      price: price.toDouble(),
      description: json[_descriptionKey],
      category: CategoryModel.fromJson(
        Map<String, dynamic>.from(json[_categoryKey]),
      ),
      images: List<String>.from(
        json[_imagesKey],
      ),
    );
  }

  // declaration of constants
  static const String _idKey = 'id';
  static const String _titleKey = 'title';
  static const String _priceKey = 'price';
  static const String _descriptionKey = 'description';
  static const String _categoryKey = 'category';
  static const String _imagesKey = 'images';

// declaration of variables
  final int id;
  final String title;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;
}
