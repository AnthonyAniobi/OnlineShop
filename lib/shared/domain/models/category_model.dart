import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdTime,
    required this.updatedTime,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json[_idKey],
        name: json[_nameKey],
        image: json[_imageKey],
        createdTime: DateTime.tryParse(json[_createdTimeKey]),
        updatedTime: DateTime.tryParse(json[_updatedTimeKey]),
      );

  // declaration of constants
  static const String _idKey = 'id';
  static const String _nameKey = 'name';
  static const String _imageKey = 'image';
  static const String _createdTimeKey = 'creationAt';
  static const String _updatedTimeKey = 'updatedAt';
  // variable names
  final int id;
  final String name;
  final String image;
  final DateTime? createdTime;
  final DateTime? updatedTime;

  @override
  List<Object?> get props => [id, name, image];
}
