import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a Notifier class that manages a Set of integers
class FavoritesNotifier extends Notifier<Set<int>> {
  // Initialize the state with an empty set
  @override
  Set<int> build() => {};

  /// add a product Id
  void addProductId(int id) {
    state = {...state, id};
  }

  bool checkIfFavoriteExists(int id) {
    return state.contains(id);
  }

  /// remove a product id from the list
  void removeProductId(int id) {
    state = state.where((element) => element != id).toSet();
  }

  // Method to clear all integers in the set
  void clearSet() {
    state = {};
  }
}

final favoriteStateProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  () => FavoritesNotifier(),
);
