import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/drug_repository.dart';
import '../domain/drug_result.dart';

class DrugSearchState {
  const DrugSearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.error,
  });
  final String query;
  final List<DrugResult> results;
  final bool isLoading;
  final String? error;

  DrugSearchState copyWith({
    String? query,
    List<DrugResult>? results,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      DrugSearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );
}

class DrugSearchController extends Notifier<DrugSearchState> {
  Timer? _debounce;
  double? _lat;
  double? _lng;

  @override
  DrugSearchState build() => const DrugSearchState();

  void setLocation(double lat, double lng) {
    _lat = lat;
    _lng = lng;
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query, clearError: true);
    if (query.trim().length < 2) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }
    state = state.copyWith(isLoading: true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    try {
      final results = await ref
          .read(drugRepositoryProvider)
          .search(query.trim(), lat: _lat, lng: _lng);
      state = state.copyWith(results: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: e.toString(), results: []);
    }
  }

  void clear() {
    _debounce?.cancel();
    state = const DrugSearchState();
  }
}

final drugSearchControllerProvider =
    NotifierProvider<DrugSearchController, DrugSearchState>(
        DrugSearchController.new);
