part of '../../core.dart';

/// Defines the structural schema, field definitions, and hierarchical relationships
/// of a form model.
///
/// [FormModelStructure] acts as the declarative blueprint for all form fields,
/// categorizing them into:
/// - **Plain Properties** ([PlainFormPropDef]): Discrete values such as text,
///   integers, booleans, dates, or files that do not require option dataset lookups.
/// - **Managed-Option Properties** ([ManagedOptFormPropDef]): Selection-based properties
///   backed by dynamic datasets ([XData]), supporting single-selection, multi-selection,
///   and hierarchical cascading dependencies between parent and child options.
///
/// Form models override `defineFormModelStructure()` to supply this configuration.
///
/// ### Example:
/// ```dart
/// @override
/// FormModelStructure defineFormModelStructure() {
///   return FormModelStructure(
///     plainPropDefs: [
///       PlainFormPropDef<int>(propName: "id"),
///       PlainFormPropDef<String>(propName: "name"),
///       PlainFormPropDef<bool>(propName: "active"),
///       PlainFormPropDef<String>(propName: "description"),
///     ],
///     managedOptPropDefs: [
///       // Single-selection dropdown/picker:
///       ManagedOptFormPropDef<ProgramTypeInfo>.singleSelection(
///         propName: "programType",
///       ),
///       // Multi-selection list or tag picker:
///       ManagedOptFormPropDef<ContributorInfo>.multiSelection(
///         propName: "contributors",
///       ),
///     ],
///   );
/// }
/// ```
class FormModelStructure {
  //
  // Prop Defs:
  //
  /// List of plain property definitions registered for this form structure.
  final List<PlainFormPropDef> __plainPropDefs;

  /// List of root managed-option property definitions registered for this form structure.
  final List<ManagedOptFormPropDef> __rootManagedOptPropDefs;

  /// Combined map of all property definitions mapped by their unique names.
  final Map<String, FormPropDef> __allPropDefMap = {};

  /// Map of plain property definitions mapped by their unique names.
  final Map<String, PlainFormPropDef> __plainPropDefMap = {};

  /// Map of managed-option property definitions mapped by their unique names.
  final Map<String, ManagedOptFormPropDef> __managedOptPropDefMap = {};

  //
  // FormPropModels:
  //
  /// Map of all instantiated property models mapped by their unique names.
  final Map<String, FormPropModel> _allPropModelMapX = {};

  /// List of root managed-option property models.
  final List<ManagedOptFormPropModel> _rootManagedOptPropModels = [];

  /// List of plain property models.
  final List<PlainFormPropModel> _plainPropModels = [];

  /// List of calculated property models.
  final List<CalculatedFormPropModel> _calculatedPropModels = [];

  //

  /// Flag indicating whether the form has been marked as dirty manually.
  bool __manualDirty = false;

  /// Flag indicating whether the form is currently running in temporary mode.
  bool __isTempMode = false;

  /// Public getter to check if the form is in temporary mode.
  bool get isTempMode => __isTempMode;

  /// The reference to the parent base form model.
  late final BaseFormModel formModel;

  /// Flag indicating whether the form has just been initialized.
  bool _justInitialized = false;

  /// Flag indicating whether the initial form data is fully ready.
  bool _formInitialDataReady = false;

  /// The internal mode of the form (e.g., creation, edit, none).
  InternalFormMode _internalFormMode = InternalFormMode.none;

  /// The current state of the form data loading/processing.
  FormDataState _formDataState = FormDataStateNone();

  /// Public getter for the current form data state.
  FormDataState get formDataState => _formDataState;

  // TODO: Delete???
  /// Stores global error information for the form if any.
  FormErrorInfo? __formErrorInfo;

  /// Checks whether the current form is in creation mode (is a new item).
  bool get isNew => _internalFormMode == InternalFormMode.creation;

  /// Initializes the form model structure with given plain and managed-option property definitions.
  FormModelStructure({
    required List<PlainFormPropDef> plainPropDefs,
    required List<ManagedOptFormPropDef> managedOptPropDefs,
  })  : __plainPropDefs = [...plainPropDefs],
        __rootManagedOptPropDefs = [...managedOptPropDefs] {
    // Initialize plain property definitions
    for (PlainFormPropDef plainPropDef in plainPropDefs) {
      __initPlainPropDef(plainPropDef: plainPropDef);
    }
    //
    // Initialize managed-option property definitions recursively (cascade)
    for (ManagedOptFormPropDef managedOptPropDef in managedOptPropDefs) {
      __initManagedOptPropDefCascade(
        managedOptPropDef: managedOptPropDef,
        parent: null,
      );
    }
    //
    // Create Prop Models:
    //
    // Instantiate models for all plain property definitions
    for (PlainFormPropDef propDef in __plainPropDefs) {
      __createPlainFormPropModel(
        plainPropDef: propDef,
      );
    }
    // Instantiate models for all managed-option property definitions recursively
    for (ManagedOptFormPropDef rootOptDef in __rootManagedOptPropDefs) {
      __createManagedOptFormPropModelCascade(
        optPropDef: rootOptDef,
        parentOptModel: null,
      );
    }
  }

  // ***************************************************************************

  /// Initializes a single plain property definition and checks for name duplicates.
  void __initPlainPropDef({
    required PlainFormPropDef plainPropDef,
  }) {
    if (__allPropDefMap.containsKey(plainPropDef.propName)) {
      throw FormPropDuplicateNameError(
        propName: plainPropDef.propName,
      );
    }
    __allPropDefMap[plainPropDef.propName] = plainPropDef;
    __plainPropDefMap[plainPropDef.propName] = plainPropDef;
  }

  // ***************************************************************************

  /// Recursively initializes managed-option property definitions and links parent-child relationships.
  void __initManagedOptPropDefCascade({
    required ManagedOptFormPropDef managedOptPropDef,
    required ManagedOptFormPropDef? parent,
  }) {
    if (__allPropDefMap.containsKey(managedOptPropDef.propName)) {
      throw FormPropDuplicateNameError(
        propName: managedOptPropDef.propName,
      );
    }
    // Init LAZY Property.
    managedOptPropDef.parent = parent;
    __allPropDefMap[managedOptPropDef.propName] = managedOptPropDef;
    __managedOptPropDefMap[managedOptPropDef.propName] = managedOptPropDef;
    //
    for (ManagedOptFormPropDef child in managedOptPropDef._children) {
      __initManagedOptPropDefCascade(
        managedOptPropDef: child,
        parent: managedOptPropDef,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Creates and registers a plain form property model from its definition.
  void __createPlainFormPropModel({
    required PlainFormPropDef plainPropDef,
  }) {
    final model = plainPropDef.createModel(
      propName: plainPropDef.propName,
    );
    _plainPropModels.add(model);
    _allPropModelMapX[plainPropDef.propName] = model;
  }

  // ***************************************************************************

  /// Recursively creates and registers managed-option form property models.
  void __createManagedOptFormPropModelCascade({
    required ManagedOptFormPropDef optPropDef,
    required ManagedOptFormPropModel? parentOptModel,
  }) {
    final model = optPropDef.createModel(
      propName: optPropDef.propName,
      parent: parentOptModel,
    );
    if (parentOptModel == null) {
      _rootManagedOptPropModels.add(model);
    }
    parentOptModel?._children.add(model);
    //
    _allPropModelMapX[optPropDef.propName] = model;
    for (ManagedOptFormPropDef childDef in optPropDef._children) {
      __createManagedOptFormPropModelCascade(
        optPropDef: childDef,
        parentOptModel: model,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Retrieves the active form error information from any property or global scope.
  FormErrorInfo? get formErrorInfo {
    for (String propName in _allPropModelMapX.keys) {
      FormPropModel prop = _allPropModelMapX[propName]!;
      if (prop._formErrorInfo != null) {
        return prop._formErrorInfo;
      }
    }
    return __formErrorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Clears error information across all properties and the global form scope.
  void _clearFormError() {
    for (String propName in _allPropModelMapX.keys) {
      FormPropModel prop = _allPropModelMapX[propName]!;
      prop._formErrorInfo = null;
    }
    __formErrorInfo = null;
  }

  /// Sets error information for a specific property or globally if no property name is specified.
  void _setFormError(FormErrorInfo formErrorInfo) {
    if (formErrorInfo.propName == null) {
      __formErrorInfo = formErrorInfo;
    } else {
      FormPropModel? prop = _allPropModelMapX[formErrorInfo.propName!];
      prop?._formErrorInfo = formErrorInfo;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (filterModelStructure.allManagedOptCriteria)
  /// Retrieves a list of all managed-option property models in the form.
  List<ManagedOptFormPropModel> get allManagedOptProps {
    return _allPropModelMapX.values
        .whereType<ManagedOptFormPropModel>()
        .cast<ManagedOptFormPropModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Marks root managed-option properties for reload if their criteria has changed.
  void _triggerFilterCriteriaChanged() {
    for (var rootManagedOptProp in _rootManagedOptPropModels) {
      if (rootManagedOptProp.reloadCondition ==
          ManagedOptPropReload.ifCriteriaChanged) {
        rootManagedOptProp._markToReload = true;
      }
    }
  }

  /// Marks root managed-option properties for reload if the item ID has changed.
  void _triggerItemIdChanged() {
    for (var rootManagedOptProp in _rootManagedOptPropModels) {
      if (rootManagedOptProp.reloadCondition ==
          ManagedOptPropReload.ifItemIdChanged) {
        rootManagedOptProp._markToReload = true;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets the internal mode of the form.
  void _setInternalFormMode(InternalFormMode internalFormMode) {
    _internalFormMode = internalFormMode;
  }

  /// Sets the current state of form data.
  void _setFormDataState({
    required FormDataState formDataState,
    required dynamic error,
  }) {
    _formDataState = formDataState;
  }

  /// Sets both the internal form mode and data state simultaneously.
  void _setInternalFormModeAndState({
    required InternalFormMode internalFormMode,
    required FormDataState formDataState,
  }) {
    _internalFormMode = internalFormMode;
    _formDataState = formDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets the manual dirty flag for the form.
  void _setManualDirty(bool manualDirty) {
    __manualDirty = manualDirty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether the form data has been modified (is dirty).
  bool _isDirty() {
    if (__manualDirty) {
      return true;
    }
    for (FormPropModel prop in _allPropModelMapX.values) {
      bool dirty = prop.isDirty();
      if (dirty) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// For the first load of an Item, update "Initial Form Data".
  /// IMPORTANT:
  /// - Other Initial [ManagedOptFormPropModel] data will be update later...
  ///
  void _setInitialFormDataForItemFirstLoad() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  ///
  /// After save successful, update "Initial Form Data".
  ///
  void _updateInitialFormDataAfterSaveSuccess() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  /// Updates current values and extra data from temporary values.
  void _updateTempToReal() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = prop._tempCurrentValue;
      prop._currentXData = prop._tempCurrentXData;
    }
  }

  ///
  /// Reset Form Data:
  /// Resets all property current values back to their initial values and clears manual dirty flag.
  void _resetFormData() {
    __manualDirty = false;
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = prop._initialValue;
      prop._currentXData = prop._initialXData;
    }
  }

  /// Clears all form data and resets the state to initial/none conditions.
  void _clearFormDataWithState({required FormDataState formDataState}) {
    _justInitialized = true;
    _formDataState = formDataState;
    _internalFormMode = InternalFormMode.none;
    __manualDirty = false;
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = null;
      prop._initialValue = null;
      if (prop is ManagedOptFormPropModel) {
        if (prop._markToReload) {
          prop._initialXData = null;
          prop._currentXData = null;
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets the current value for a specific property by its name.
  void _setCurrentPropValue({
    required String propName,
    required dynamic value,
  }) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop != null) {
      prop._currentValue = value;
    }
  }

  /// Retrieves the current value of a specific property by its name.
  dynamic _getCurrentPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop != null) {
      return prop._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: DELETE?
  /// Returns initial form data map (placeholder/legacy).
  Map<String, dynamic> get initial0FormData {
    return {};
  }

  /// Returns a map of all property names mapped to their initial values.
  Map<String, dynamic> get _initialFormData {
    return _allPropModelMapX.map((k, v) => MapEntry(k, v._initialValue));
  }

  /// Returns a map of all property names mapped to their current values.
  Map<String, dynamic> get _currentFormData {
    return _allPropModelMapX.map((k, v) => MapEntry(k, v._currentValue));
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Finds and returns a managed-option form property model by its name.
  ManagedOptFormPropModel? _getManagedOptFormProp(String managedOptPropName) {
    FormPropModel? prop = _allPropModelMapX[managedOptPropName];
    if (prop is ManagedOptFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Finds and returns a plain form property model by its name.
  PlainFormPropModel? _getPlainFormProp(String propName) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is PlainFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if a property with the given name is a managed-option form property.
  bool _isManagedOptFormProp(String propName) {
    return _getManagedOptFormProp(propName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets up temporary states for starting or updating a form activity.
  void _setupTemporaryStateForNewActivity({
    required FormActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
  }) {
    __isTempMode = true;
    __addPropsIfNeed(
      propNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      switch (activityType) {
        case FormActivityType.startCreatingOrEditing:
          _formInitialDataReady = false;
          if (prop is PlainFormPropModel) {
            prop._tempCurrentValue = null;
            prop._tempCurrentXData = null;
            prop._tempInitialValue = null;
            prop._tempInitialXData = null;
          } else if (prop is ManagedOptFormPropModel) {
            if (prop._markToReload && prop.parent == null) {
              prop._tempCurrentValue = null;
              prop._tempCurrentXData = null;
              prop._tempInitialValue = null;
              prop._tempInitialXData = null;
            } else {
              prop._tempInitialXData = prop._initialXData;
              prop._tempCurrentXData = prop._currentXData;
              if (_internalFormMode == InternalFormMode.edit) {
                prop._tempInitialValue = prop._initialValue;
                prop._tempCurrentValue = prop._currentValue;
              } else {
                prop._tempInitialValue = null;
                prop._tempCurrentValue = null;
              }
            }
          } else {
            // Never throw.
            throw UnimplementedError("_setupTemporaryStateForNewActivity");
          }
        case FormActivityType.updateFromFormView:
          prop._tempCurrentValue = prop._currentValue;
          prop._tempCurrentXData = prop._currentXData;
          prop._tempInitialValue = prop._initialValue;
          prop._tempInitialXData = prop._initialXData;
          //
          if (formKeyInstantValues.containsKey(prop.propName)) {
            if (prop is PlainFormPropModel) {
              prop._tempCurrentValue = formKeyInstantValues[prop.propName];
            }
          }
        case FormActivityType.patchFormFields:
          prop._tempCurrentValue = prop._currentValue;
          prop._tempCurrentXData = prop._currentXData;
          prop._tempInitialValue = prop._initialValue;
          prop._tempInitialXData = prop._initialXData;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Retrieves the temporary current value of a property by its name.
  dynamic _getTempCurrentPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._tempCurrentValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Retrieves the temporary initial value of a property by its name.
  dynamic _getTempInitialPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._tempInitialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Retrieves the initial value of a property by its name.
  dynamic _getInitialPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._initialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Retrieves the temporary extra data (`XData`) of a managed-option property.
  XData? _getTempManagedOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is ManagedOptFormPropModel) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  /// Retrieves the current extra data (`XData`) of a managed-option property.
  XData? _getCurrentManagedOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is ManagedOptFormPropModel) {
      return prop._currentXData;
    }
    return null;
  }

  /// Retrieves the raw data inside the extra data (`XData`) of a managed-option property.
  dynamic _getCurrentManagedOptPropData({required String propName}) {
    XData? managedOptPropXData =
        _getCurrentManagedOptPropXData(propName: propName);
    return managedOptPropXData?.data;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Finds and returns a managed-option form property model by its name.
  ManagedOptFormPropModel? _findManagedOptFormProp(String managedOptPropName) {
    FormPropModel? prop = _allPropModelMapX[managedOptPropName];
    if (prop is ManagedOptFormPropModel) {
      return prop;
    }
    return null;
  }

  /// Debug helper to get the load count of a managed-option property.
  int _debugGetManagedOptPropLoadCount({
    required String managedOptPropName,
  }) {
    ManagedOptFormPropModel? prop = _findManagedOptFormProp(managedOptPropName);
    return prop?._loadCount ?? 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Recursively updates children managed-option values to null.
  void _updateChildrenManagedOptValueToNullCascade({
    required ManagedOptFormPropModel managedOptProp,
  }) {
    for (ManagedOptFormPropModel child in managedOptProp._children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenManagedOptValueToNullCascade(managedOptProp: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Updates temporary values for properties based on provided value maps.
  void _updatePropsTempValues(Map<String, dynamic> propValues) {
    __addPropsIfNeed(
      propNames: propValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...propValues};
    //
    // IMPORTANT:
    // Update data for FormPropsStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptProp data to null if parent-Value is null or not selected.
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._markTempDirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      FormPropModel? prop = _allPropModelMapX[propName];
      if (prop != null) {
        prop._markTempDirty = true;
      }
    }
    //
    for (ManagedOptFormPropModel rootProp in _rootManagedOptPropModels) {
      rootProp._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (PlainFormPropModel commonItem in _plainPropModels) {
      commonItem._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Prop:
    for (FormPropModel prop in _allPropModelMapX.values) {
      if (prop._markTempDirty) {
        prop._tempCurrentValue = prop._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any properties are missing and adds them dynamically if needed.
  void __addPropsIfNeed({required List<String> propNames}) {
    for (String propName in propNames) {
      FormPropModel? prop = _allPropModelMapX[propName];
      if (prop == null) {
        print("""\n
            ****************************************************************************************************
            *** WARNING ***: You should declare prop '$propName' explicitly in ${getClassName(formModel)}.
            ****************************************************************************************************
            """);
        //
        __createAndAddNewPlainProp(
          propName: propName,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Creates and adds a new plain property model dynamically.
  void __createAndAddNewPlainProp({
    required String propName,
    required bool markTempDirty,
  }) {
    if (_allPropModelMapX.containsKey(propName)) {
      return;
    }
    PlainFormPropModel newPlainProp = PlainFormPropModel(
      propName: propName,
    );
    __initPlainProp(
      newPlainProp: newPlainProp,
      markTempDirty: markTempDirty,
    );
  }

  /// Initializes and registers a new plain property model.
  void __initPlainProp({
    required PlainFormPropModel newPlainProp,
    required bool markTempDirty,
  }) {
    newPlainProp._structure = this;
    newPlainProp._markTempDirty = markTempDirty;
    _allPropModelMapX[newPlainProp.propName] = newPlainProp;
    _plainPropModels.add(newPlainProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Initializes and registers a new calculated property model.
  void __initCalculatedProp({
    required CalculatedFormPropModel newCalculatedProp,
    required bool markTempDirty,
  }) {
    newCalculatedProp._structure = this;
    newCalculatedProp._markTempDirty = markTempDirty;
    _allPropModelMapX[newCalculatedProp.propName] = newCalculatedProp;
    _calculatedPropModels.add(newCalculatedProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets temporary extra data (`XData`) for a managed-option property.
  void _setTempManagedOptPropXData({
    required String managedOptPropName,
    required XData? managedOptPropXData,
  }) {
    FormPropModel? prop = _allPropModelMapX[managedOptPropName];
    if (prop == null) {
      throw AppError(errorMessage: 'No Prop "$managedOptPropName"');
    }
    if (prop is ManagedOptFormPropModel) {
      prop._tempCurrentXData = managedOptPropXData;
    } else {
      throw AppError(
        errorMessage:
            'Invalid Prop "$managedOptPropName", it must be $ManagedOptFormPropModel',
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets temporary value and optionally initial value for a plain property.
  void _setTempPlainPropValue({
    required String propName,
    required Object? value,
    required bool setForInitial,
  }) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop == null) {
      throw AppError(
        errorMessage: 'No propName "$propName"',
        errorDetails: null,
      );
    } else if (prop is! PlainFormPropModel) {
      throw AppError(
        errorMessage: '"$propName" is not $PlainFormPropModel',
        errorDetails: null,
      );
    }
    prop._tempCurrentValue = value;
    if (setForInitial) {
      prop._tempInitialValue = value;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Debug getter for root managed-option property models.
  @DebugMethodAnnotation()
  List<ManagedOptFormPropModel> get debugRootManagedOptProps =>
      _rootManagedOptPropModels;

  /// Debug getter for plain property models.
  @DebugMethodAnnotation()
  List<PlainFormPropModel> get plainProps => _plainPropModels;

  // ***************************************************************************
  // ***************************************************************************

  /// Prints temporary debugging information for the form structure.
  void _printTemporaryInfo(String prefix) {
    if (true) {
      print(
          "\n\n--------------------------------------------------------------");
      print(" ---> $prefix");
      for (ManagedOptFormPropModel rootItem in _rootManagedOptPropModels) {
        rootItem._printTempInfoCascade(indentFactor: 1);
      }
      print("--------------------------------------------------------------");
    }
  }
}
