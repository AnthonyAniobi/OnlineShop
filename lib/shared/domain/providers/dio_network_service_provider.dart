import 'package:online_shop/shared/services/rest_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final netwokServiceProvider = Provider<RestService>(
  (ref) {
    return RestService();
  },
);
