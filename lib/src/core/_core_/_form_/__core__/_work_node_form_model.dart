part of '../../core.dart';

/// Intermediate base class for forms operating within an [Activity] context ([Task] and [Stage]).
///
/// Encapsulates common lifecycle workflows driven by transactional [INIT_DATA]
/// rather than entity item details managed by a [Shelf].
abstract class WorkNodeFormModel<
INIT_DATA extends Object,
RESULT_DATA extends Object,
FORM_PATCH extends FormPatch,
FORM_OUTPUT extends FormOutput,
ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<FORM_PATCH,
        FORM_OUTPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  Activity get activity;

  @override
  Activity get relatedModule => activity;

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
  Map<String, dynamic>? _internalResolveInitialPlainPropValues({
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
      methodName: "extractPlainPropValuesFromInitData",
      suffixShortDesc: "",
      parameters: {
        "additionalFormRelatedData": additionalFormRelatedData,
        "initData": currentInitData,
      },
    );
    return extractPlainPropValuesFromInitData(
      additionalFormRelatedData: additionalFormRelatedData,
      initData: currentInitData,
    );
  }

  @override
  OptValueWrap? _internalResolveInitialManagedOptPropValue({
    required ExecutionTrace executionTrace,
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    final INIT_DATA? currentInitData = initData;
    if (currentInitData == null) {
      return null;
    }

    executionTrace.addControllableCall(
      codeId: "#098200",
      caller: this,
      methodName: "extractManagedOptPropValueFromInitData",
      suffixShortDesc: "",
      parameters: {
        "managedOptPropName": managedOptPropName,
        "parentManagedOptPropValue": parentManagedOptPropValue,
        "managedOptSelectionMode": managedOptSelectionMode,
        "managedOptPropXData": managedOptPropXData,
        "initData": currentInitData,
        "additionalFormRelatedData": additionalFormRelatedData,
      },
    );
    OptValueWrap? valueWrap = extractManagedOptPropValueFromInitData(
      managedOptPropName: managedOptPropName,
      managedOptSelectionMode: managedOptSelectionMode,
      managedOptPropXData: managedOptPropXData,
      parentManagedOptPropValue: parentManagedOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      initData: currentInitData,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "extractManagedOptPropValueFromInitData",
        managedOptPropName: managedOptPropName,
      );
    }
    return valueWrap;
  }

  @override
  Future<XData?> _internalPerformLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object? rawDomainData,
  }) {
    return performLoadManagedOptPropXData(
      managedOptPropName: managedOptPropName,
      managedOptSelectionMode: managedOptSelectionMode,
      parentManagedOptPropValue: parentManagedOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
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

  @AbstractMethodAnnotation()
  Future<XData?> performLoadManagedOptPropXData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA? initData,
  });

  @AbstractMethodAnnotation()
  Map<String, dynamic>? extractPlainPropValuesFromInitData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  @AbstractMethodAnnotation()
  OptValueWrap? extractManagedOptPropValueFromInitData({
    required String managedOptPropName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptPropXData,
    required Object? parentManagedOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required INIT_DATA initData,
  });

  @AbstractMethodAnnotation()
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
