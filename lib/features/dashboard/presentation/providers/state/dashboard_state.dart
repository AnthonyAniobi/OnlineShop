// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';

enum DashboardLoadingState {
  initial,
  loading,
  loaded,
  failure;

  bool get isInitial => this == initial;
  bool get isLoading => this == loading;
  bool get isLoaded => this == loaded;
  bool get isFailed => this == failure;
}

class DashboardState extends Equatable {
  const DashboardState({
    this.productList = const [],
    this.isLoading = false,
    this.hasData = false,
    this.loadingState = DashboardLoadingState.initial,
    this.message = '',
  });

  const DashboardState.initial({
    this.productList = const [],
    this.isLoading = false,
    this.hasData = false,
    this.loadingState = DashboardLoadingState.initial,
    this.message = '',
  });

  DashboardState copyWith({
    List<Product>? productList,
    bool? hasData,
    DashboardLoadingState? loadingState,
    String? message,
    bool? isLoading,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
      hasData: hasData ?? this.hasData,
      loadingState: loadingState ?? this.loadingState,
      message: message ?? this.message,
    );
  }

  final List<Product> productList;
  final bool hasData;
  final DashboardLoadingState loadingState;
  final String message;
  final bool isLoading;

  @override
  String toString() {
    return 'DashboardState(isLoading:$isLoading, productLength: ${productList.length}, hasData: $hasData, loadingState: $loadingState, message: $message)';
  }

  @override
  List<Object?> get props => [productList, hasData, loadingState, message];
}
