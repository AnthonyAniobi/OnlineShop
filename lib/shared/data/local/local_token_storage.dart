import 'package:hive_flutter/hive_flutter.dart';

class LocalTokenStorage {
  static const boxName = "LOGIN_TOKEN_BOX";
  static const _token = "TOKEN";

  static late Box<dynamic> box;

  static Future init() async {
    box = await Hive.openBox<dynamic>(boxName);
  }

  static String? getToken() => box.get(_token);

  static void updateToken(String token) => box.put(_token, token);
  static Future reset() => box.clear();
}
