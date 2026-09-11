part of '../core.dart';

/// Configuration options defining the runtime behavior and execution policies
/// of a [FilterModel].
///
/// This configuration serves as the immutable baseline provided during the
/// initialization of a filter model, determining how criteria mutations are
/// propagated to bound blocks.
class FilterModelConfig {
  /// Defines the application policy governing how filter criteria transitions
  /// are committed from draft state to applied state.
  ///
  /// Defaults to [FilterApplyPolicy.explicit].
  final FilterApplyPolicy applyPolicy;

  /// Creates an immutable configuration instance for a [FilterModel].
  const FilterModelConfig({
    this.applyPolicy = FilterApplyPolicy.explicit,
  });

  /// Creates a copy of this configuration instance with identical properties.
  FilterModelConfig copy() {
    return FilterModelConfig(applyPolicy: applyPolicy);
  }
}
