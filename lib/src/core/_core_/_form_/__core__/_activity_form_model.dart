part of '../../core.dart';

/// Intermediate base class for forms operating within an [Activity] context ([Task] and [Stage]).
///
/// Encapsulates common lifecycle workflows driven by transactional [INIT_DATA]
/// rather than entity item details managed by a [Shelf].
abstract class ActivityFormModel<
        INIT_DATA extends Object,
        RESULT_DATA extends Object,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<CREATION_PRESET, FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  Activity get activity;

  @override
  Shelf? get relatedShelf => null;

  @override
  Object? get rawDomainData => initData;

  /// Returns the current baseline initialization data resolved by the owning unit.
  INIT_DATA? get initData;

  @override
  ActivityFormMode get formMode => _internalFormMode.toActivityFormMode();

  ActivityFormModel({super.config});

  // ===========================================================================
  // POLYMORPHIC BRIDGES IMPLEMENTATION
  // ===========================================================================

  @override
  Future<XData?> _internalPerformLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required Object? rawDomainData,
  }) {
    return performLoadMultiOptPropXDataForInitData(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      parentMultiOptPropValue: parentMultiOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      formInput: formInput,
      initData: rawDomainData as INIT_DATA?,
    );
  }

  @override
  Map<String, dynamic>? _internalExtractSimplePropValuesFromDomainData({
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  }) {
    return extractSimplePropValuesFromInitData(
      additionalFormRelatedData: additionalFormRelatedData,
      initData: rawDomainData as INIT_DATA,
    );
  }

  @override
  OptValueWrap? _internalExtractMultiOptPropValueFromDomainData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required Object rawDomainData,
  }) {
    return extractMultiOptPropValueFromInitData(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      multiOptPropXData: multiOptPropXData,
      parentMultiOptPropValue: parentMultiOptPropValue,
      additionalFormRelatedData: additionalFormRelatedData,
      initData: rawDomainData as INIT_DATA,
    );
  }

  @override
  Future<ADDITIONAL_FORM_RELATED_DATA>
      _internalPerformLoadAdditionalFormRelatedData({
    required Object? rawDomainData,
  }) {
    return performLoadAdditionalFormRelatedDataForInitData(
      initData: rawDomainData as INIT_DATA?,
    );
  }

  @override
  Map<String, dynamic>? _internalSpecifyCreationValuesForSimpleProps({
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    return specifyCreationValuesForSimpleProps(
      creationPreset: creationPreset,
      additionalFormRelatedData: additionalFormRelatedData,
    );
  }

  @override
  OptValueWrap? _internalSpecifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET? creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  }) {
    return specifyCreationValueForMultiOptProp(
      multiOptPropName: multiOptPropName,
      selectionType: selectionType,
      multiOptPropXData: multiOptPropXData,
      parentMultiOptPropValue: parentMultiOptPropValue,
      creationPreset: creationPreset,
      additionalFormRelatedData: additionalFormRelatedData,
    );
  }

  // ===========================================================================
  // ABSTRACT CONTRACTS (User override in concrete FormModels)
  // ===========================================================================

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyCreationValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required CREATION_PRESET? creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyCreationValuesForSimpleProps({
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptPropXDataForInitData({
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
  Future<ADDITIONAL_FORM_RELATED_DATA>
      performLoadAdditionalFormRelatedDataForInitData({
    required INIT_DATA? initData,
  });

  // ===========================================================================
  // COMMON ACTIVITY-LEVEL HOOKS & CONTROLS
  // ===========================================================================

  Type getInitDataType() => INIT_DATA;
  Type getResultDataType() => RESULT_DATA;
  Type getFormInputType() => FORM_INPUT;

  @override
  void _addToRecent() => FlutterArtist.desk._addRecentActivity(activity);

  @override
  void _triggerWhenFormViewVisible() =>
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addActivity(activity);

  @override
  bool _canResetForm() => isEnabled() && isDirty();

  @override
  void _refreshAllViews() => activity.ui.refreshAllViews();
}
