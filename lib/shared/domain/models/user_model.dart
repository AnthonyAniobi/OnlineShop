import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
    required this.createdTime,
    required this.updatedTime,
  });

  factory User.fromJson(Map<String, dynamic> map) => User(
        id: map[_idKey] ?? 0,
        name: map[_nameKey] ?? '',
        password: map[_passwordKey] ?? '',
        email: map[_emailKey] ?? '',
        role: map[_roleKey] ?? '',
        avatar: map[_avatarKey] ?? '',
        createdTime: DateTime.tryParse(map[_creationAtKey]) ?? DateTime.now(),
        updatedTime: DateTime.tryParse(map[_updatedAtKey]) ?? DateTime.now(),
      );

  User copyWith({
    int? id,
    String? password,
    String? email,
    String? name,
    String? role,
    String? avatar,
    DateTime? createdTime,
    DateTime? updatedTime,
  }) {
    return User(
      id: id ?? this.id,
      password: password ?? this.password,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      updatedTime: updatedTime ?? this.updatedTime,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static const String _idKey = 'id';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _nameKey = 'name';
  static const String _roleKey = 'role';
  static const String _avatarKey = 'avatar';
  static const String _creationAtKey = 'creationAt';
  static const String _updatedAtKey = 'updatedAt';

  final int id;
  final String email;
  final String password;
  final String name;
  final String role;
  final String avatar;
  final DateTime createdTime;
  final DateTime updatedTime;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _idKey: id,
      _emailKey: email,
      _passwordKey: password,
      _nameKey: name,
      _roleKey: role,
      _avatarKey: avatar,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        name,
        role,
        avatar,
        createdTime,
        updatedTime,
      ];
}
