part of '../../core.dart';

/// Defines the structural schema, field definitions, and hierarchical relationships
/// of a form model.
///
/// [FormModelStructure] acts as the declarative blueprint for all form fields,
/// categorizing them into:
/// - **Simple Properties** ([SimpleFormPropDef]): Discrete values such as text,
///   integers, booleans, dates, or files that do not require option dataset lookups.
/// - **Multi-Option Properties** ([MultiOptFormPropDef]): Selection-based properties
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
///     simplePropDefs: [
///       SimpleFormPropDef<int>(propName: "id"),
///       SimpleFormPropDef<String>(propName: "name"),
///       SimpleFormPropDef<bool>(propName: "active"),
///       SimpleFormPropDef<String>(propName: "description"),
///     ],
///     multiOptPropDefs: [
///       // Single-selection dropdown/picker:
///       MultiOptFormPropDef<ProgramTypeInfo>.singleSelection(
///         propName: "programType",
///       ),
///       // Multi-selection list or tag picker:
///       MultiOptFormPropDef<ContributorInfo>.multiSelection(
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
  /// List of simple property definitions registered for this form structure.
  final List<SimpleFormPropDef> __simplePropDefs;

  /// List of root multi-option property definitions registered for this form structure.
  final List<MultiOptFormPropDef> __rootMultiOptPropDefs;

  /// Combined map of all property definitions mapped by their unique names.
  final Map<String, FormPropDef> __allPropDefMap = {};

  /// Map of simple property definitions mapped by their unique names.
  final Map<String, SimpleFormPropDef> __simplePropDefMap = {};

  /// Map of multi-option property definitions mapped by their unique names.
  final Map<String, MultiOptFormPropDef> __multiOptPropDefMap = {};

  //
  // FormPropModels:
  //
  /// Map of all instantiated property models mapped by their unique names.
  final Map<String, FormPropModel> _allPropModelMapX = {};

  /// List of root multi-option property models.
  final List<MultiOptFormPropModel> _rootOptPropModels = [];

  /// List of simple property models.
  final List<SimpleFormPropModel> _simplePropModels = [];

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

  /// Initializes the form model structure with given simple and multi-option property definitions.
  FormModelStructure({
    required List<SimpleFormPropDef> simplePropDefs,
    required List<MultiOptFormPropDef> multiOptPropDefs,
  })
      : __simplePropDefs = [...simplePropDefs],
        __rootMultiOptPropDefs = [...multiOptPropDefs] {
    // Initialize simple property definitions
    for (SimpleFormPropDef simplePropDef in simplePropDefs) {
      __initSimplePropDef(simplePropDef: simplePropDef);
    }
    //
    // Initialize multi-option property definitions recursively (cascade)
    for (MultiOptFormPropDef multiOptPropDef in multiOptPropDefs) {
      __initMultiOptPropDefCascade(
        multiOptPropDef: multiOptPropDef,
        parent: null,
      );
    }
    //
    // Create Prop Models:
    //
    // Instantiate models for all simple property definitions
    for (SimpleFormPropDef propDef in __simplePropDefs) {
      __createSimpleFormPropModel(
        simplePropDef: propDef,
      );
    }
    // Instantiate models for all multi-option property definitions recursively
    for (MultiOptFormPropDef rootOptDef in __rootMultiOptPropDefs) {
      __createMultiOptFormPropModelCascade(
        optPropDef: rootOptDef,
        parentOptModel: null,
      );
    }
  }

  // ***************************************************************************

  /// Initializes a single simple property definition and checks for name duplicates.
  void __initSimplePropDef({
    required SimpleFormPropDef simplePropDef,
  }) {
    if (__allPropDefMap.containsKey(simplePropDef.propName)) {
      throw FormPropDuplicateNameError(
        propName: simplePropDef.propName,
      );
    }
    __allPropDefMap[simplePropDef.propName] = simplePropDef;
    __simplePropDefMap[simplePropDef.propName] = simplePropDef;
  }

  // ***************************************************************************

  /// Recursively initializes multi-option property definitions and links parent-child relationships.
  void __initMultiOptPropDefCascade({
    required MultiOptFormPropDef multiOptPropDef,
    required MultiOptFormPropDef? parent,
  }) {
    if (__allPropDefMap.containsKey(multiOptPropDef.propName)) {
      throw FormPropDuplicateNameError(
        propName: multiOptPropDef.propName,
      );
    }
    // Init LAZY Property.
    multiOptPropDef.parent = parent;
    __allPropDefMap[multiOptPropDef.propName] = multiOptPropDef;
    __multiOptPropDefMap[multiOptPropDef.propName] = multiOptPropDef;
    //
    for (MultiOptFormPropDef child in multiOptPropDef._children) {
      __initMultiOptPropDefCascade(
        multiOptPropDef: child,
        parent: multiOptPropDef,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Creates and registers a simple form property model from its definition.
  void __createSimpleFormPropModel({
    required SimpleFormPropDef simplePropDef,
  }) {
    final model = simplePropDef.createModel(
      propName: simplePropDef.propName,
    );
    _simplePropModels.add(model);
    _allPropModelMapX[simplePropDef.propName] = model;
  }

  // ***************************************************************************

  /// Recursively creates and registers multi-option form property models.
  void __createMultiOptFormPropModelCascade({
    required MultiOptFormPropDef optPropDef,
    required MultiOptFormPropModel? parentOptModel,
  }) {
    final model = optPropDef.createModel(
      propName: optPropDef.propName,
      parent: parentOptModel,
    );
    if (parentOptModel == null) {
      _rootOptPropModels.add(model);
    }
    parentOptModel?._children.add(model);
    //
    _allPropModelMapX[optPropDef.propName] = model;
    for (MultiOptFormPropDef childDef in optPropDef._children) {
      __createMultiOptFormPropModelCascade(
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

  // SAME-AS: #0007 (filterModelStructure.allMultiOptCriteria)
  /// Retrieves a list of all multi-option property models in the form.
  List<MultiOptFormPropModel> get allMultiOptProps {
    return _allPropModelMapX.values
        .whereType<MultiOptFormPropModel>()
        .cast<MultiOptFormPropModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Marks root multi-option properties for reload if their criteria has changed.
  void _triggerFilterCriteriaChanged() {
    for (var rootMultiOptProp in _rootOptPropModels) {
      if (rootMultiOptProp.reloadCondition ==
          MultiOptPropReload.ifCriteriaChanged) {
        rootMultiOptProp._markToReload = true;
      }
    }
  }

  /// Marks root multi-option properties for reload if the item ID has changed.
  void _triggerItemIdChanged() {
    for (var rootMultiOptProp in _rootOptPropModels) {
      if (rootMultiOptProp.reloadCondition ==
          MultiOptPropReload.ifItemIdChanged) {
        rootMultiOptProp._markToReload = true;
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
  /// - Other Initial [MultiOptFormPropModel] data will be update later...
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
      if (prop is MultiOptFormPropModel) {
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

  /// Finds and returns a multi-option form property model by its name.
  MultiOptFormPropModel? _getMultiOptFormProp(String multiOptPropName) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop is MultiOptFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Finds and returns a simple form property model by its name.
  SimpleFormPropModel? _getSimpleFormProp(String propName) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is SimpleFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if a property with the given name is a multi-option form property.
  bool _isMultiOptFormProp(String propName) {
    return _getMultiOptFormProp(propName) != null;
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
          if (prop is SimpleFormPropModel) {
            prop._tempCurrentValue = null;
            prop._tempCurrentXData = null;
            prop._tempInitialValue = null;
            prop._tempInitialXData = null;
          } else if (prop is MultiOptFormPropModel) {
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
            if (prop is SimpleFormPropModel) {
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

  /// Retrieves the temporary extra data (`XData`) of a multi-option property.
  XData? _getTempMultiOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is MultiOptFormPropModel) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  /// Retrieves the current extra data (`XData`) of a multi-option property.
  XData? _getCurrentMultiOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is MultiOptFormPropModel) {
      return prop._currentXData;
    }
    return null;
  }

  /// Retrieves the raw data inside the extra data (`XData`) of a multi-option property.
  dynamic _getCurrentMultiOptPropData({required String propName}) {
    XData? multiOptPropXData = _getCurrentMultiOptPropXData(propName: propName);
    return multiOptPropXData?.data;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Finds and returns a multi-option form property model by its name.
  MultiOptFormPropModel? _findMultiOptFormProp(String multiOptPropName) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop is MultiOptFormPropModel) {
      return prop;
    }
    return null;
  }

  /// Debug helper to get the load count of a multi-option property.
  int _debugGetMultiOptPropLoadCount({
    required String multiOptPropName,
  }) {
    MultiOptFormPropModel? prop = _findMultiOptFormProp(multiOptPropName);
    return prop?._loadCount ?? 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Recursively updates children multi-option values to null.
  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptFormPropModel multiOptProp,
  }) {
    for (MultiOptFormPropModel child in multiOptProp._children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptProp: child);
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
    for (MultiOptFormPropModel rootProp in _rootOptPropModels) {
      rootProp._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFormPropModel commonItem in _simplePropModels) {
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
            *** WARNING ***: You should declare prop '$propName' explicitly in ${getClassName(
            formModel)}.
            ****************************************************************************************************
            """);
        //
        __createAndAddNewSimpleProp(
          propName: propName,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Creates and adds a new simple property model dynamically.
  void __createAndAddNewSimpleProp({
    required String propName,
    required bool markTempDirty,
  }) {
    if (_allPropModelMapX.containsKey(propName)) {
      return;
    }
    SimpleFormPropModel newSimpleProp = SimpleFormPropModel(
      propName: propName,
    );
    __initSimpleProp(
      newSimpleProp: newSimpleProp,
      markTempDirty: markTempDirty,
    );
  }

  /// Initializes and registers a new simple property model.
  void __initSimpleProp({
    required SimpleFormPropModel newSimpleProp,
    required bool markTempDirty,
  }) {
    newSimpleProp._structure = this;
    newSimpleProp._markTempDirty = markTempDirty;
    _allPropModelMapX[newSimpleProp.propName] = newSimpleProp;
    _simplePropModels.add(newSimpleProp);
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

  /// Sets temporary extra data (`XData`) for a multi-option property.
  void _setTempMultiOptPropXData({
    required String multiOptPropName,
    required XData? multiOptPropXData,
  }) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop == null) {
      throw AppError(errorMessage: 'No Prop "$multiOptPropName"');
    }
    if (prop is MultiOptFormPropModel) {
      prop._tempCurrentXData = multiOptPropXData;
    } else {
      throw AppError(
        errorMessage:
        'Invalid Prop "$multiOptPropName", it must be $MultiOptFormPropModel',
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Sets temporary value and optionally initial value for a simple property.
  void _setTempSimplePropValue({
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
    } else if (prop is! SimpleFormPropModel) {
      throw AppError(
        errorMessage: '"$propName" is not $SimpleFormPropModel',
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

  /// Debug getter for root multi-option property models.
  @DebugMethodAnnotation()
  List<MultiOptFormPropModel> get debugRootOptProps => _rootOptPropModels;

  /// Debug getter for simple property models.
  @DebugMethodAnnotation()
  List<SimpleFormPropModel> get simpleProps => _simplePropModels;

  // ***************************************************************************
  // ***************************************************************************

  /// Prints temporary debugging information for the form structure.
  void _printTemporaryInfo(String prefix) {
    if (true) {
      print(
          "\n\n--------------------------------------------------------------");
      print(" ---> $prefix");
      for (MultiOptFormPropModel rootItem in _rootOptPropModels) {
        rootItem._printTempInfoCascade(indentFactor: 1);
      }
      print("--------------------------------------------------------------");
    }
  }
}
