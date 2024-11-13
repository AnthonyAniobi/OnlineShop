import 'package:online_shop/configs/app_data_types.dart';
import 'package:online_shop/features/dashboard/domain/repositories/product_repository.dart';
import 'package:online_shop/features/dashboard/presentation/providers/state/dashboard_state.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final ProductRepository repository;

  DashboardNotifier(
    this.repository,
  ) : super(const DashboardState.initial());

  Future<void> fetchProducts() async {
    state = state.copyWith(
      loadingState: DashboardLoadingState.loading,
    );

    final response = await repository.fetchProducts();

    updateStateFromResponse(response);
  }

  Future<void> searchProducts(String query) async {
    state = state.copyWith(
      loadingState: DashboardLoadingState.loading,
    );

    final response = await repository.searchProducts(
      query: query,
    );

    updateStateFromResponse(response);
  }

  void updateStateFromResponse(ApiErrorOr<List<Product>> response) {
    response.fold((failure) {
      state = state.copyWith(
        loadingState: DashboardLoadingState.failure,
        message: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        productList: data,
        loadingState: DashboardLoadingState.loaded,
        hasData: true,
        message: data.isEmpty ? 'No products found' : '',
      );
    });
  }

  void resetState() {
    state = const DashboardState.initial();
  }
}
