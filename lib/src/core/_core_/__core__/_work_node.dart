part of '../core.dart';

abstract class WorkNode<
    INIT_DATA extends Object, //
    RESULT_DATA extends Object, //
    FORM_INPUT extends FormInput,
    FORM_OUTPUT extends FormOutput> extends _Core implements FormHost {
  final String name;
  final String? description;

  Activity get activity;

  Activity get module => activity;

  @override
  WorkNodeFormModel<
      INIT_DATA, //
      RESULT_DATA,
      FORM_INPUT,
      FORM_OUTPUT,
      AdditionalFormRelatedData>? get formModel;

  // ===========================================================================
  // EMBEDDED TASK STATE STORAGE
  // ===========================================================================

  bool __isLoadingInitData = false;

  bool get isLoadingInitData => __isLoadingInitData;

  bool __isSubmitting = false;

  bool get isSubmitting => __isSubmitting;

  bool get hasForm;

  bool get hasError;

  INIT_DATA? _initData;

  INIT_DATA? get initData => _initData;

  RESULT_DATA? _lastResultData;

  RESULT_DATA? get lastResultData => _lastResultData;

  // ===========================================================================
  // Constructor
  // ===========================================================================

  WorkNode({
    required this.name,
    this.description,
  });

  // ===========================================================================
  // GENERICS TYPES:
  // ===========================================================================

  Type getInitDataType() => INIT_DATA;

  Type getResultDataType() => RESULT_DATA;

  Type getFormInputType() => FORM_INPUT;

  // ===========================================================================
  // COMMON METHODS
  // ===========================================================================

  /// Clears shared node data and resets embedded cache.
  void clear() {
    _initData = null;
    _lastResultData = null;
  }

  /// Updates loading state and triggers control bars refresh safely.
  void __refreshLoadingInitDataState({required bool isLoading}) {
    try {
      __isLoadingInitData = isLoading;
      // ui.refreshControlBars();
      _refreshControlBars();
    } catch (_) {}
  }

  void _refreshControlBars();
}
