part of '../../core.dart';

/// Intermediate base class for forms operating within an [Activity] context ([Task] and [Stage]).
///
/// Encapsulates common lifecycle workflows driven by transactional [INIT_DATA]
/// rather than entity item details managed by a [Shelf].
abstract class WorkNodeFormModel<
        INIT_DATA extends Object,
        RESULT_DATA extends Object,
        FORM_INPUT extends FormInput,
        FORM_OUTPUT extends FormOutput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<FORM_INPUT, FORM_OUTPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  Activity get activity;

  @override
  Shelf? get relatedShelf => null;

  @override
  Object? get rawDomainData => initData;

  /// Returns the current baseline initialization data resolved by the owning unit.
  INIT_DATA? get initData;

  @override
  WorkNodeFormMode get formMode => _internalFormMode.toWorkNodeFormMode();

  WorkNodeFormModel({super.config});

  // ===========================================================================
  // POLYMORPHIC BRIDGES IMPLEMENTATION
  // ===========================================================================

  @override
  Map<String, dynamic>? _internalResolveInitialSimplePropValues({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    final INIT_DATA? currentInitData = initData;
    if (currentInitData == null) {
      return null;
    }

    executionTrace.addControllableCall(
      codeId: "#096200",
      caller: this,
      methodName: "extractSimplePropValuesFromInitData",
      suffixShortDesc: "",
      parameters: {
        "additionalFormRelatedData": additionalFormRelatedData,
        "initData": currentInitData,
      },
    );
    return extractSimplePropValuesFromInitData(
      additionalFormRelatedData: additionalFormRelatedData,
      initData: currentInitData,
    );
  }

  @override
  OptValueWrap? _internalResolveInitialMultiOptPropValue({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    final INIT_DATA? currentInitData = initData;
    if (currentInitData == null) {
      return null;
    }

    executionTrace.addControllableCall(
      codeId: "#098200",
      caller: this,
      methodName: "extractMultiOptPropValueFromInitData",
      suffixShortDesc: "",
      parameters: {
        "multiOptPropName": multiOptPropName,
        "parentMultiOptPropValue": parentMultiOptPropValue,
        "selectionType": selectionType,
        "multiOptPropXData": multiOptPropXData,
        "initData": currentInitData,
        "additionalFormRelatedData": additionalFormRelatedData,
      },
    );
    OptValueWrap? valueWrap = extractMultiOptPropValueFromInitData(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      multiOptPropXData: multiOptPropXData,
      parentMultiOptPropValue: parentMultiOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      initData: currentInitData,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "extractMultiOptPropValueFromInitData",
        multiOptPropName: multiOptPropName,
      );
    }
    return valueWrap;
  }

  @override
  Future<XData?> _internalPerformLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required Object? rawDomainData,
  }) {
    return performLoadMultiOptPropXData(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      parentMultiOptPropValue: parentMultiOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      formInput: formInput,
      initData: rawDomainData as INIT_DATA?,
    );
  }

  @override
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  }) {
    return performLoadAdditionalFormRelatedData(
      initData: rawDomainData as INIT_DATA?,
    );
  }

  // ===========================================================================
  // ABSTRACT CONTRACTS (User override in concrete FormModels)
  // ===========================================================================

  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required INIT_DATA? initData,
  });

  @_AbstractMethodAnnotation()
  Map<String, dynamic>? extractSimplePropValuesFromInitData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  @_AbstractMethodAnnotation()
  OptValueWrap? extractMultiOptPropValueFromInitData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required INIT_DATA? initData,
  });

  // ===========================================================================
  // COMMON ACTIVITY-LEVEL HOOKS & CONTROLS
  // ===========================================================================

  Type getInitDataType() => INIT_DATA;
  Type getResultDataType() => RESULT_DATA;

  @override
  void _triggerWhenFormViewVisible() =>
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addActivity(activity);

  @override
  bool _checkBeforeResetForm() => isEnabled() && isDirty();

  @override
  void _refreshAllViews() => activity.ui.refreshAllViews();
}
