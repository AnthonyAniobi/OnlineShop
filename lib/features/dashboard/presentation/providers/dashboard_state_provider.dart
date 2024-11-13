//
import 'package:online_shop/features/dashboard/domain/providers/product_providers.dart';
import 'package:online_shop/features/dashboard/presentation/providers/state/dashboard_notifier.dart';
import 'package:online_shop/features/dashboard/presentation/providers/state/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return DashboardNotifier(repository)..fetchProducts();
});
