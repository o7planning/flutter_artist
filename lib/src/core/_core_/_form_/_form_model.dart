part of '../core.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Identifiable<ID>,
    FORM_INPUT extends FormInput,
    ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData // AdditionalFormRelatedData
    > extends _Core {
  final FormModelConfig config;

  int __loadCount = 0;

  int get loadCount => __loadCount;

  int _saveErrorCount = 0;

  int get saveErrorCount => _saveErrorCount;

  int __formActivityCount = 0;

  int get formActivityCount => __formActivityCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get pathInfo {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  ADDITIONAL_FORM_RELATED_DATA? __additionalFormRelatedData;
  FORM_INPUT? __creationFormInput;

  bool _changeEventLocked = false;

  bool _loadTimeUiActive = false;

  bool get loadTimeUiActive => _loadTimeUiActive;

  FormMode get formMode => _formPropsStructure.formMode;

  DataState get dataState => _formPropsStructure._formDataState;

  FormErrorInfo? get formErrorInfo => _formPropsStructure.formErrorInfo;

  bool get formInitialDataReady => _formPropsStructure._formInitialDataReady;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Identifiable<ID>, // ITEM
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> block;

  bool _defaultSimpleValuesInitiated = false;
  bool _defaultMultiOptValuesInitiated = false;

  bool get defaultSimpleValuesInitiated => _defaultSimpleValuesInitiated;

  bool get defaultMultiOptValuesInitiated => _defaultMultiOptValuesInitiated;

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  AutovalidateMode get _autovalidateModeForFormView {
    if (_formPropsStructure._formMode == FormMode.none) {
      return AutovalidateMode.disabled;
    }
    return _autovalidateMode;
  }

  late final ui = _FormUiComponents(formModel: this);

  // ***************************************************************************

  late final FormModelStructure _formPropsStructure;

  FormModelStructure get formPropsStructure => _formPropsStructure;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // ***************************************************************************
  // ***************************************************************************

  FormModel({
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormModelConfig config = const FormModelConfig(),
  })  : config = config.copy(),
        _autovalidateMode = config.autovalidateMode {
    __defineFormModelStructure();
  }

  // ***************************************************************************

  XFormModel<ID, ITEM_DETAIL> _createXFormModel({
    required FORM_INPUT? formInput,
  }) {
    return XFormModel<ID, ITEM_DETAIL>._(
      formModel: this,
      formInput: formInput,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// FormModelStructure defineFormModelStructure() {
  ///   return FormModelStructure(
  ///     simplePropDefs: [
  ///       SimpleFormPropDef<int>(propName: "id"),
  ///       SimpleFormPropDef<String>(propName: "name"),
  ///       SimpleFormPropDef<String>(propName: "email"),
  ///       SimpleFormPropDef<String>(propName: "address"),
  ///       SimpleFormPropDef<String>(propName: "phone"),
  ///       SimpleFormPropDef<bool>(propName: "active"),
  ///       SimpleFormPropDef<String>(propName: "description"),
  ///       // dynamic or List<XFile>
  ///       SimpleFormPropDef<dynamic>(propName: "xFiles"),
  ///     ],
  ///     multiOptPropDefs: [
  ///       // Multi Option Single Selection Prop.
  ///       MultiOptFormPropDef<SupplierTypeInfo>.singleSelection(
  ///         propName: 'supplierType',
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FormModelStructure defineFormModelStructure();

  // ***************************************************************************
  // ***************************************************************************

  /// In all the cases: @itemDetail not null or @formInput not null or both.
  ///
  /// In case of you are editing an ITEM with and FormInput
  /// then @itemDetail & @formInput will be not null.
  ///
  /// ```
  /// Case FormActivityType.startCreatingOrEditing:
  ///     - @formMode = FormMode.creation:
  ///         - @itemDetail     --> Null.
  ///         - @formInput --> Not null.
  ///     - @formMode = FormMode.edit:
  ///         - @itemDetail     --> Not Null.
  ///         - @formInput --> Null or Not null.
  ///
  /// Case FormActivityType.patchFormFields:
  ///     - @formMode = FormMode.creation:
  ///         - @itemDetail     --> Null.
  ///         - @formInput --> Not null.
  ///     - @formMode = FormMode.edit:
  ///         - @itemDetail     --> Not Null.
  ///         - @formInput --> Not null. -
  ///
  /// Case FormActivityType.updateFromFormView:
  ///     - @formMode = FormMode.creation:
  ///         - @itemDetail     --> Null.
  ///         - @formInput --> Not Null.
  ///     - @formMode = FormMode.edit:
  ///         - @itemDetail     --> Not Null.
  ///         - @formInput --> Null or Not null.
  /// ```
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required ITEM_DETAIL? itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyDefaultValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// If this Block HAS a parent Block:
  /// ```dart
  ///  Map<String, dynamic>? specifyDefaultValuesForSimpleProps({
  ///     required Object? parentBlockCurrentItemId,
  ///  }) {
  ///     return {
  ///        // ID of current item of parent Block.
  ///        "companyId": parentBlockCurrentItemId,
  ///        "departmentName": "Some Name",
  ///     };
  ///  }
  /// ```
  ///
  /// If this Block HAS NO a parent Block:
  /// ```dart
  ///  Map<String, dynamic>? specifyDefaultValuesForSimpleProps({
  ///     required Object? parentBlockCurrentItemId,
  ///  }) {
  ///     return {
  ///        "departmentName": "Some Name",
  ///     };
  ///  }
  /// ```
  ///
  // SAME-AS: #0011 (filter - specifyDefaultValuesForSimpleTildeCriteria)
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForSimpleProps({
    required Object? parentBlockCurrentItemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? extractMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// [itemDetail] should include the ID of the parent Block's currentItem.
  /// Let's look at an example with class [DepartmentFormModel]:
  /// ```dart
  ///  Map<String, dynamic>? extractSimplePropValuesFromItemDetail({
  ///      required Object? parentBlockCurrentItemId,
  ///      required AdditionalFormRelatedData additionalFormRelatedData,
  ///      required DepartmentData itemDetail,
  ///  }) {
  ///     return {
  ///        "companyId": itemDetail.companyId,
  ///        "departmentName": itemDetail.name,
  ///     };
  ///  }
  /// ```
  ///
  /// [additionalFormRelatedData] can include other information from the parent Block's [currentItem].
  /// ```dart
  ///  Map<String, dynamic>? extractSimplePropValuesFromItemDetail({
  ///      required Object? parentBlockCurrentItemId,
  ///      required DepartmentFormRelatedData additionalFormRelatedData,
  ///      required DepartmentData itemDetail,
  ///  }) {
  ///     return {
  ///        "companyId": itemDetail.companyId,
  ///        "companyName": additionalFormRelatedData.companyName,
  ///        "departmentName": itemDetail.name,
  ///     };
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? extractSimplePropValuesFromItemDetail({
    required Object? parentBlockCurrentItemId,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  // OLD: getMultiOptPropValueFromFormInput.
  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required Object? parentBlockCurrentItemId,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT formInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  /// ```dart
  ///  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
  ///     required Object? parentBlockCurrentItemId,
  ///     required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  ///     required DepartmentFormInput formInput,
  ///  }) {
  ///     return {
  ///        "departmentName": SimpleValueWrap.useIfNotNull(formInput.name),
  ///        "departmentPhone": SimpleValueWrap.useIfNotNull(formInput.phone),
  ///     };
  ///  }
  /// ```
  /// Note: In your design, [FormInput] should not include the ID of the parent Block's [currentItem].
  ///
  // OLD: extractUpdateValuesForSimpleProps.
  // SAME-AS: #0010 (filter - extractUpdateValuesForSimpleTildeCriteria)
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
    required Object? parentBlockCurrentItemId,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT formInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performCreateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performUpdateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Type getIdType() {
    return ID;
  }

  Type getItemDetailType() {
    return ITEM_DETAIL;
  }

  Type getFormInputType() {
    return FORM_INPUT;
  }

  @DebugMethodAnnotation()
  String get debugClassDefinition {
    return "${getClassName(this)}$debugClassParametersDefinition";
  }

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition {
    return "<${getIdType()}, ${getItemDetailType()}, ${getFormInputType()}>";
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showFormErrorViewerDialog(BuildContext context) async {
    if (dataState != DataState.error) {
      return;
    }
    await FormErrorViewerDialog.open(
      context: context,
      formErrorInfo: formErrorInfo!,
      formInitialDataReady: formInitialDataReady,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _triggerFilterCriteriaChanged() {
    _formPropsStructure._triggerFilterCriteriaChanged();
  }

  void _triggerItemIdChanged() {
    _formPropsStructure._triggerItemIdChanged();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormViewChangeAnnotation()
  Future<bool> _unitFormViewChanged({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XFormModel xFormModel,
  }) async {
    __assertThisXFormModel(xFormModel);
    //
    executionTrace._addTraceStep(
      codeId: "#36000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    await _startNewFormActivity(
      executionTrace: executionTrace,
      additionalFormRelatedData: null,
      formInput: null,
      activityType: FormActivityType.updateFromFormView,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelLoadDataAnnotation()
  Future<bool> _unitLoadFormData({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XFormModel thisXFormModel,
    required FormModelDataLoadResult taskResult,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    executionTrace._addTraceStep(
      codeId: "#37000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    final bool forceReloadForm;
    switch (thisXFormModel.forceTypeForForm) {
      case ForceType.force:
        forceReloadForm = true;
      case ForceType.decidedAtRuntime:
        // forceReloadForm =
        //     formDataState != DataState.ready && hasActiveUiComponent();
        forceReloadForm = false;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#37060",
      shortDesc:
          "Calculate >>  @forceReloadForm: ${debugObjHtml(forceReloadForm)}",
    );
    //
    if (!forceReloadForm) {
      if (dataState != DataState.ready) {
        executionTrace._addTraceStep(
          codeId: "#37100",
          shortDesc:
              "${debugObjHtml(this)} - @dataState: ${debugObjHtml(dataState)} --> Clear data and set to <b>pending</b>.",
        );
        _clearDataWithDataState(formDataState: DataState.pending);
      }
      executionTrace._addTraceStep(
        codeId: "#37120",
        shortDesc:
            "@forceReloadForm: ${debugObjHtml(forceReloadForm)} --> do nothing.",
      );
      return true;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#37160",
      shortDesc:
          "Calling ${debugObjHtml(block)}._performLoadAdditionalFormRelatedData().",
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData =
        await block._performLoadAdditionalFormRelatedData(executionTrace);
    if (additionalFormRelatedData == null) {
      return false;
    }
    //
    final formInput = thisXFormModel.formInput as FORM_INPUT?;
    final activityType = FormActivityType.startCreatingOrEditing;
    //
    executionTrace._addTraceStep(
      codeId: "#37260",
      shortDesc: "Calling ${debugObjHtml(this)}._startNewFormActivity().",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
        "additionalFormRelatedData": additionalFormRelatedData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    // TODO: Bắt lỗi cho vào "taskResult" ???????
    return await _startNewFormActivity(
      executionTrace: executionTrace,
      additionalFormRelatedData: additionalFormRelatedData,
      formInput: formInput,
      activityType: activityType,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<bool> _unitPatchFormFields({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XFormModel thisXFormModel,
    required FORM_INPUT formInput,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    executionTrace._addTraceStep(
      codeId: "#38000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    final ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData = null;
    final activityType = FormActivityType.patchFormFields;

    executionTrace._addTraceStep(
      codeId: "#38100",
      shortDesc: "Calling ${debugObjHtml(this)}._startNewFormActivity().",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
        "additionalFormRelatedData": additionalFormRelatedData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    //
    await _startNewFormActivity(
      executionTrace: executionTrace,
      additionalFormRelatedData: additionalFormRelatedData, // null
      formInput: formInput,
      activityType: activityType,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelSaveFormAnnotation()
  Future<void> _unitSaveForm({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XFormModel<ID, ITEM_DETAIL> thisXFormModel,
    required FormSaveResult taskResult,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    executionTrace._addTraceStep(
      codeId: "#11000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      lineFlowType: LineFlowType.debug,
    );
    //
    // No need to check again?
    //
    Actionable<BlockFormSavePrecheck> actionable = block.__canSaveForm(
      checkBusy: true,
      checkAllow: true,
      checkValidate: true,
    );
    if (!actionable.yes) {
      return;
    }
    final Map<String, dynamic> formMapData =
        _formPropsStructure.currentFormData;
    //
    String calledMethodName = _formPropsStructure.isNew //
        ? 'performCreateItem'
        : 'performUpdateItem';
    //
    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
    final bool isNew = _formPropsStructure.isNew;
    try {
      block._refreshSavingState(isSaving: true);
      //
      executionTrace._addTraceStep(
        codeId: "#11400",
        shortDesc: "Calling ${debugObjHtml(this)}.$calledMethodName()...",
        parameters: {
          "formMapData": formMapData,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      //
      result = isNew
          ? await performCreateItem(formMapData: formMapData)
          : await performUpdateItem(formMapData: formMapData);
    } catch (e, stackTrace) {
      saveError = true;
      //
      final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: calledMethodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: isNew
              ? TipDocument.formModelPerformCreateItem
              : TipDocument.formModelPerformUpdateItem);
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#11500",
        shortDesc:
            "The ${debugObjHtml(this)}.$calledMethodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      //
      return;
    } finally {
      block._refreshSavingState(isSaving: false);
    }
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#11800",
        shortDesc:
            "Calling ${debugObjHtml(this)}._processSaveActionRestResult().",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      await block._processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXFormModel.xBlock,
        isNew: isNew,
        callingClassName: getClassNameWithoutGenerics(this),
        calledMethodName: calledMethodName,
        result: result,
      );
      return;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#11900",
        shortDesc:
            "The ${debugObjHtml(this)}.$calledMethodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      //
      return;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __defineFormModelStructure() {
    try {
      _formPropsStructure = defineFormModelStructure();
      _formPropsStructure.formModel = this;
    }
    // Invalid Form Prop.
    on FormPropInvalidNameError catch (e) {
      String message = "Invalid Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate Form Prop.
    on FormPropDuplicateNameError catch (e) {
      String message = "Duplicate Form propName '${e.propName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFormModelStructure()' method for details.";
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @_ImportantMethodAnnotation(
      "Called when Form Data is being loaded or user makes changes in FormView")
  Future<bool> _startNewFormActivity({
    required ExecutionTrace executionTrace,
    required ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData,
    required FORM_INPUT? formInput,
    required FormActivityType activityType,
  }) async {
    __formActivityCount++;
    //
    executionTrace._addTraceStep(
      codeId: "#06000",
      shortDesc: "${debugObjHtml(this)} Form View Changed.",
    );
    //
    if (activityType == FormActivityType.startCreatingOrEditing) {
      __loadCount++;
      _autovalidateMode = AutovalidateMode.disabled;
    } else {
      _autovalidateMode = config.autovalidateMode;
    }
    //
    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final FormMode currentFormMode;
    switch (activityType) {
      case FormActivityType.startCreatingOrEditing:
        currentFormMode = itemDetail == null //
            ? FormMode.creation
            : FormMode.edit;
        //
        _formPropsStructure._clearFormError();
        _formPropsStructure._setFormDataState(
          formDataState: DataState.pending,
          error: null,
        );
        if (currentFormMode == FormMode.creation) {
          __creationFormInput = formInput;
        } else {
          __creationFormInput = null;
        }
        if (additionalFormRelatedData == null) {
          throw DevError(
            errorMessage:
                "Dev Error. additionalFormRelatedData must be not null if FormModel.activityType = startCreatingOrEditing.",
          );
        }
        __additionalFormRelatedData = additionalFormRelatedData;
      case FormActivityType.updateFromFormView:
        currentFormMode = formMode;
        if (additionalFormRelatedData != null) {
          throw DevError(
            errorMessage:
                "Dev Error. additionalFormRelatedData must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        additionalFormRelatedData = __additionalFormRelatedData!;
        if (formInput != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formInput must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        if (currentFormMode == FormMode.creation) {
          formInput = __creationFormInput;
        }
      case FormActivityType.patchFormFields:
        currentFormMode = formMode;
        if (additionalFormRelatedData != null) {
          throw DevError(
            errorMessage:
                "Dev Error. additionalFormRelatedData must be null if FormModel.activityType = patchFormFields.",
          );
        }
        additionalFormRelatedData = __additionalFormRelatedData!;
        if (formInput == null) {
          throw DevError(
            errorMessage:
                "Dev Error. formInput must be not null if FormModel.activityType = patchFormFields.",
          );
        }
    }
    //
    _formPropsStructure._setFormMode(currentFormMode);
    final bool isNoneMode = currentFormMode == FormMode.none;
    final bool isCreationMode = currentFormMode == FormMode.creation;
    //
    if (activityType == FormActivityType.startCreatingOrEditing) {
      if (isNoneMode || isCreationMode) {
        _defaultSimpleValuesInitiated = false;
        _defaultMultiOptValuesInitiated = false;
      }
    }
    //
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    _formPropsStructure._setupTemporaryStateForNewActivity(
      activityType: activityType,
      // Data from FormView:
      formKeyInstantValues: formKeyInstantValues,
    );
    //
    // Get SimpleProp Value:
    //
    // FormActivityType.startCreatingOrEditing (Begin Create or Update).
    if (activityType == FormActivityType.startCreatingOrEditing) {
      if (itemDetail != null) {
        executionTrace._addTraceStep(
          codeId: "#06180",
          shortDesc: "Editing item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
          lineFlowType: LineFlowType.debug,
        );
        try {
          executionTrace._addTraceStep(
            codeId: "#06200",
            lineFlowType: LineFlowType.controllableCalling,
            shortDesc:
                "Calling ${debugObjHtml(this)}.extractSimplePropValuesFromItemDetail().",
            parameters: {
              "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
              "itemDetail": itemDetail,
              "additionalFormRelatedData": additionalFormRelatedData,
            },
          );
          var simplePropValueMap = extractSimplePropValuesFromItemDetail(
                parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                additionalFormRelatedData: additionalFormRelatedData,
                itemDetail: itemDetail,
              ) ??
              {};
          for (String propName in simplePropValueMap.keys) {
            // Check and throw error if 'propName' is not a SimpleFormProp:
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod:
                  FormErrorMethod.extractSimplePropValuesFromItemDetail,
            );
            //
            // In (First load + itemDetail != null).
            //
            dynamic value = simplePropValueMap[propName];
            _formPropsStructure._setTempSimplePropValue(
              propName: propName,
              value: value,
              setForInitial: true,
            );
          }
        } catch (e, stackTrace) {
          dynamic error = e;
          if (e is FormPropTypeMismatchError) {
            // Bug: #Bug#004
            error = e.toAppError(
              formModelName: getClassNameWithoutGenerics(this),
            );
          }
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod:
                FormErrorMethod.extractSimplePropValuesFromItemDetail,
            error: error,
            errorStackTrace: stackTrace,
          );
          _formPropsStructure._setFormError(formErrorInfo);
          //
          final ErrorInfo errorInfo = _handleError(
            shelf: shelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: null,
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          executionTrace._addTraceStep(
            codeId: "#06400",
            shortDesc:
                "The ${debugObjHtml(this)}.extractSimplePropValuesFromItemDetail() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
      // itemDetail == null. [[Currently Condition: startCreatingOrEditing && itemDetail == null]].
      else {
        executionTrace._addTraceStep(
          codeId: "#06500",
          shortDesc: "Creating item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
          lineFlowType: LineFlowType.debug,
        );
        Map<String, dynamic> simplePropValueDefault = {};
        if (!_defaultSimpleValuesInitiated) {
          executionTrace._addTraceStep(
            codeId: "#06520",
            shortDesc:
                "@_defaultSimpleValuesInitiated = false --> Need to init default simple values.",
          );
          try {
            executionTrace._addTraceStep(
              codeId: "#06540",
              shortDesc:
                  "Calling ${debugObjHtml(this)}.specifyDefaultValuesForSimpleProps().",
              parameters: {
                "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
              },
              lineFlowType: LineFlowType.controllableCalling,
            );
            // In case of activityType = startCreatingOrEditing.
            simplePropValueDefault = specifyDefaultValuesForSimpleProps(
                  parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                ) ??
                {};
            //
            for (String propName in simplePropValueDefault.keys) {
              // Check and throw error if 'propName' is not a SimpleFormProp:
              __throwErrorIfNotASimplePropName(
                propName: propName,
                formErrorMethod:
                    FormErrorMethod.specifyDefaultValuesForSimpleProps,
              );
              //
              // In (Item First Load + itemDetail == null + !_defaultValueInitiated).
              //
              dynamic value = simplePropValueDefault[propName];
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: value,
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod:
                  FormErrorMethod.specifyDefaultValuesForSimpleProps,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formPropsStructure._setFormError(formErrorInfo);
            //
            final ErrorInfo errorInfo = _handleError(
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument:
                  TipDocument.formModelSpecifyDefaultValuesForSimpleProps,
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              activityType: activityType,
              error: e,
            );
            executionTrace._addTraceStep(
              codeId: "#06580",
              shortDesc:
                  "The ${debugObjHtml(this)}.specifyDefaultValuesForSimpleProps() method was called with an error!",
              errorInfo: errorInfo,
            );
            return false;
          }
        }
        //
        // In Condition: startCreatingOrEditing && itemDetail == null.
        // TODO: Handle Error:
        //
        formInput ??= block.__buildInputForCreationForm(executionTrace);
        if (formInput != null) {
          try {
            executionTrace._addTraceStep(
              codeId: "#06620",
              shortDesc:
                  "Calling ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps().",
              parameters: {
                "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
                "formInput": formInput,
                "additionalFormRelatedData": additionalFormRelatedData,
              },
              lineFlowType: LineFlowType.controllableCalling,
            );
            final Map<String, SimpleValueWrap?> updatedSimplePropValues =
                extractUpdateValuesForSimpleProps(
                      parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                      additionalFormRelatedData: additionalFormRelatedData,
                      formInput: formInput!,
                    ) ??
                    {};
            //
            for (String propName in updatedSimplePropValues.keys) {
              // Check and throw error if 'propName' is not a SimpleFormProp:
              __throwErrorIfNotASimplePropName(
                propName: propName,
                formErrorMethod:
                    FormErrorMethod.extractUpdateValuesForSimpleProps,
              );
              //
              // In (ItemFirstLoad + formInput != null).
              //
              SimpleValueWrap? valueWrap = updatedSimplePropValues[propName];
              // SAME-AS: #0012 (filterModel)
              if (valueWrap != null) {
                _formPropsStructure._setTempSimplePropValue(
                  propName: propName,
                  value: valueWrap.value,
                  setForInitial: true,
                );
              }
            }
          } catch (e, stackTrace) {
            final formErrorInfo = FormErrorInfo(
              activityType: activityType,
              propName: null,
              formErrorMethod:
                  FormErrorMethod.extractUpdateValuesForSimpleProps,
              error: e,
              errorStackTrace: stackTrace,
            );
            _formPropsStructure._setFormError(formErrorInfo);
            //
            final ErrorInfo errorInfo = _handleError(
              shelf: shelf,
              methodName: formErrorInfo.methodName,
              error: formErrorInfo.error,
              stackTrace: formErrorInfo.errorStackTrace,
              showSnackBar: true,
              tipDocument: TipDocument.formModelGetUpdatedValuesForSimpleProps,
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              error: e,
              activityType: activityType,
            );
            //
            executionTrace._addTraceStep(
              codeId: "#06660",
              shortDesc:
                  "The ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps() method was called with an error!",
              errorInfo: errorInfo,
            );
            return false;
          }
        }
      }
    } // end of "startCreatingOrEditing".
    // Begin of 'patchFormFields'.
    else if (activityType == FormActivityType.patchFormFields) {
      executionTrace._addTraceStep(
        codeId: "#06700",
        shortDesc: "Enter Form Fields."
            "\n - @activityType: <b>$activityType</b>."
            "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
        lineFlowType: LineFlowType.debug,
      );
      if (formInput != null) {
        try {
          executionTrace._addTraceStep(
            codeId: "#06720",
            shortDesc:
                "Calling ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps() with parameters:",
            parameters: {
              "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
              "formInput": formInput,
              "additionalFormRelatedData": additionalFormRelatedData,
            },
            lineFlowType: LineFlowType.controllableCalling,
          );
          final Map<String, SimpleValueWrap?> updatedSimplePropValues =
              extractUpdateValuesForSimpleProps(
                    parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                    additionalFormRelatedData: additionalFormRelatedData,
                    formInput: formInput,
                  ) ??
                  {};
          //
          for (String propName in updatedSimplePropValues.keys) {
            // Check and throw error if 'propName' is not a SimpleFormProp:
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod:
                  FormErrorMethod.extractUpdateValuesForSimpleProps,
            );
            //
            // In (patchFormFields + formInput != null)
            //
            SimpleValueWrap? valueWrap = updatedSimplePropValues[propName];
            if (valueWrap != null) {
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: valueWrap.value,
                setForInitial: false,
              );
            }
          }
        } catch (e, stackTrace) {
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod: FormErrorMethod.extractUpdateValuesForSimpleProps,
            error: e,
            errorStackTrace: stackTrace,
          );
          _formPropsStructure._setFormError(formErrorInfo);
          //
          final ErrorInfo errorInfo = _handleError(
            shelf: shelf,
            methodName: formErrorInfo.methodName,
            error: formErrorInfo.error,
            stackTrace: formErrorInfo.errorStackTrace,
            showSnackBar: true,
            tipDocument: TipDocument.formModelGetUpdatedValuesForSimpleProps,
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          executionTrace._addTraceStep(
            codeId: "#06760",
            shortDesc:
                "The ${debugObjHtml(this)}.extractUpdateValuesForSimpleProps() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
    } // End of 'patchFormFields'.
    //
    // Load MultiOptProp Data (All cases of activityType).
    //
    try {
      for (MultiOptFormPropModel multiOptProp
          in _formPropsStructure._rootOptPropModels) {
        executionTrace._addTraceStep(
          codeId: "#06780",
          shortDesc:
              "Calling ${debugObjHtml(this)}._loadMultiOptPropDataCascade() "
              "to load data for ${debugObjHtml(multiOptProp)} and its descendants.",
          parameters: {
            "additionalFormRelatedData": additionalFormRelatedData,
            "formInput": formInput,
            "parentMultiOptPropValue": null,
            "parentValueIsInitialValue": true,
            "multiOptProp": multiOptProp,
            "formKeyInstantValues": formKeyInstantValues,
            "activityType": activityType,
          },
          lineFlowType: LineFlowType.nonControllableCalling,
        );
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError or FormTempError.
        //
        await _loadMultiOptPropDataCascade(
          executionTrace: executionTrace,
          additionalFormRelatedData: additionalFormRelatedData,
          formInput: formInput,
          parentMultiOptPropValue: null,
          parentValueIsInitialValue: true,
          multiOptProp: multiOptProp,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final FormErrorInfo formErrorInfo;
      if (e is FormMethodError) {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: e.propName,
          formErrorMethod: e.formErrorMethod,
          error: e.error,
          errorStackTrace: e.stackTrace,
        );
      } else if (e is FormPropTypeMismatchError) {
        // Bug: #Bug#005
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e.toAppError(
            formModelName: getClassNameWithoutGenerics(this),
          ),
          errorStackTrace: stackTrace,
        );
      } else {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e,
          errorStackTrace: stackTrace,
        );
      }
      _formPropsStructure._setFormError(formErrorInfo);
      //
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: formErrorInfo.methodName,
        error: formErrorInfo.error,
        stackTrace: formErrorInfo.errorStackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      //
      __endFormActivityWithDataState(
        formDataState: DataState.error,
        activityType: activityType,
        error: e,
      );
      executionTrace._addTraceStep(
        codeId: "#06800",
        shortDesc:
            "The ${debugObjHtml(this)}.${formErrorInfo.methodName}() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    return __endFormActivityWithDataState(
      formDataState: DataState.ready,
      activityType: activityType,
      error: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimplePropName({
    required String propName,
    required FormErrorMethod formErrorMethod,
  }) {
    if (_formPropsStructure._isMultiOptFormProp(propName)) {
      throw DevError(
        errorMessage:
            '$propName is not a ${getTypeNameWithoutGenerics(SimpleFormPropModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(formErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __endFormActivityWithDataState({
    required DataState formDataState,
    required FormActivityType activityType,
    required dynamic error,
  }) {
    try {
      //
      // Update Real FromData from Temporary FormData:
      //
      _formPropsStructure._updateTempToReal();
      //
      if (activityType == FormActivityType.startCreatingOrEditing) {
        _formPropsStructure._setInitialFormDataForItemFirstLoad();
      }
      //
      // IMPORTANT: (Called on Field.onChanged).
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      // _defaultValueInitiated = true;
      _formPropsStructure._setFormDataState(
        formDataState: formDataState,
        error: error,
      );
      //
      if (activityType == FormActivityType.startCreatingOrEditing) {
        if (formDataState == DataState.ready) {
          _formPropsStructure._formInitialDataReady = true;
        }
      }
      // Form Disabled:
      if (!_formPropsStructure._formInitialDataReady) {
        // Clear form validation error
      }
      // Form Initial Data Ready
      else {
        // Validate Form
        if (activityType == FormActivityType.startCreatingOrEditing) {
          if (formMode == FormMode.edit && _formKey.currentState != null) {
            if (_formPropsStructure._formInitialDataReady) {
              _formKey.currentState!.validate(focusOnInvalid: false);
            }
          }
        }
      }
      //
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "__applyWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _formPropsStructure._setFormDataState(
        formDataState: DataState.error,
        error: e,
      );
      return false;
    } finally {
      _formPropsStructure.__isTempMode = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData(String prefix) {
    _formPropsStructure._printTemporaryInfo(prefix);
    print("instantData: ${_formKey.currentState?.instantValue}\n\n");
  }

  // ***************************************************************************
  // ***************************************************************************

  // TestCase [16a]-changeSupplierType.
  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      _formKey.currentState?.patchValue(newCurrentValue);
    } finally {
      //
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptPropDataCascade({
    required final ExecutionTrace executionTrace,
    required final FormActivityType activityType,
    required final ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required final FORM_INPUT? formInput,
    required final Object? parentMultiOptPropValue,
    required final MultiOptFormPropModel multiOptProp,
    required final bool parentValueIsInitialValue,
    required final Map<String, dynamic> formKeyInstantValues,
  }) async {
    final String multiOptPropName = multiOptProp.propName;
    final SelectionType selectionType = multiOptProp.selectionType;

    executionTrace._addTraceStep(
      codeId: "#17000",
      shortDesc:
          "Loading Data for ${debugObjHtml(multiOptProp)} and its children..",
      lineFlowType: LineFlowType.info,
    );

    // Get current OptProp data:
    XData? tempMultiOptPropXData =
        _formPropsStructure._getTempMultiOptPropXData(
      propName: multiOptPropName,
    );

    final dynamic tempInitialMultiOptValue = _formPropsStructure
        ._getTempInitialPropValue(propName: multiOptPropName);
    final dynamic tempCurrentMultiOptValue = _formPropsStructure
        ._getTempCurrentPropValue(propName: multiOptPropName);

    //
    dynamic newSelectedValue = _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );
    if (activityType == FormActivityType.updateFromFormView) {
      if (formKeyInstantValues.containsKey(multiOptPropName)) {
        newSelectedValue = formKeyInstantValues[multiOptPropName];
      }
    }
    //
    final bool valueChanged;
    if (tempMultiOptPropXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    //
    final bool multiOptValueIsInitialValue;
    if (tempMultiOptPropXData == null) {
      multiOptValueIsInitialValue = false;
    } else {
      multiOptValueIsInitialValue = tempMultiOptPropXData.isSameItemOrItemList(
        itemOrItemList1: tempInitialMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    //
    multiOptProp._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      executionTrace._addTraceStep(
        codeId: "#17200",
        shortDesc:
            "Value of <b>'$multiOptPropName'</b> has changed --> Clear data of all descendant <b>MultiOptFormProp(s)</b>.",
        lineFlowType: LineFlowType.info,
      );
      _formPropsStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptProp: multiOptProp,
      );
    }
    //
    if (tempMultiOptPropXData == null) {
      _formPropsStructure._setTempMultiOptPropXData(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({
        multiOptPropName: null,
      });
    }
    //
    bool forceReload = activityType != FormActivityType.updateFromFormView &&
        multiOptProp.parent == null &&
        multiOptProp._markToReload;
    //
    // Load OptProp data from Rest API.
    // May throw ApiError.
    //
    if (tempMultiOptPropXData == null || forceReload) {
      // Always increase "_loadCount" value regardless of error.
      multiOptProp._loadCount++;
      //
      try {
        executionTrace._addTraceStep(
          codeId: "#17400",
          shortDesc:
              "Calling ${debugObjHtml(this)}.performLoadMultiOptPropXData().",
          parameters: {
            "multiOptPropName": multiOptPropName,
            "parentMultiOptPropValue": parentMultiOptPropValue,
            "selectionType": selectionType,
            "itemDetail": block.currentItemDetail,
            "formInput": formInput,
            "additionalFormRelatedData": additionalFormRelatedData,
          },
          lineFlowType: LineFlowType.controllableCalling,
        );
        // May throw AppError, ApiError or others.
        tempMultiOptPropXData = await performLoadMultiOptPropXData(
          formInput: formInput,
          itemDetail: block.currentItemDetail,
          additionalFormRelatedData: additionalFormRelatedData,
          parentMultiOptPropValue: parentMultiOptPropValue,
          multiOptPropName: multiOptPropName,
          selectionType: selectionType,
        );
      } catch (e, stackTrace) {
        throw FormMethodError(
          propName: multiOptPropName,
          formErrorMethod: FormErrorMethod.performLoadMultiOptPropXData,
          error: e, // May be AppError, ApiError or others.
          stackTrace: stackTrace,
        );
      }
      //
      multiOptProp._markToReload = false;
      multiOptProp._tempCurrentXData = tempMultiOptPropXData;
    }
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    OptValueWrap? initialValueWrap;
    final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;
    //
    if (tempMultiOptPropXData != null) {
      // Item First Load:
      if (activityType == FormActivityType.startCreatingOrEditing) {
        if (currentItemDetail == null) {
          executionTrace._addTraceStep(
            codeId: "#17500",
            shortDesc:
                "(In _loadMultiOptPropDataCascade() method for ${debugObjHtml(multiOptProp)}):",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "tempMultiOptPropXData": tempMultiOptPropXData,
              "formInput": formInput,
            },
            lineFlowType: LineFlowType.debug,
          );
          // In startCreatingOrEditing & currentItemDetail == null.
          if (!_defaultMultiOptValuesInitiated) {
            // May throw FormTempError.
            initialValueWrap = __specifyDefaultValueForMultiOptProp(
              executionTrace: executionTrace,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              multiOptPropXData: tempMultiOptPropXData,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            executionTrace._addTraceStep(
              codeId: "#17540",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
            );
          }
          if (formInput != null && formInput is! EmptyFormInput) {
            // May throw FormTempError.
            initialValueWrap = __extractUpdateValueForMultiOptProp(
              executionTrace: executionTrace,
              additionalFormRelatedData: additionalFormRelatedData,
              formInput: formInput,
              multiOptPropXData: tempMultiOptPropXData,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            executionTrace._addTraceStep(
              codeId: "#17560",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
            );
          }
        }
        // currentItemDetail != null
        else {
          executionTrace._addTraceStep(
            codeId: "#17580",
            shortDesc: "Debug:",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "tempMultiOptPropXData": tempMultiOptPropXData,
              "formInput": formInput,
            },
            lineFlowType: LineFlowType.debug,
          );
          // May throw FormTempError.
          initialValueWrap = __extractMultiOptPropValueFromItemDetail(
            executionTrace: executionTrace,
            additionalFormRelatedData: additionalFormRelatedData,
            itemDetail: currentItemDetail,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
          executionTrace._addTraceStep(
            codeId: "#17590",
            shortDesc: "Got value: ${debugObjHtml(initialValueWrap)}",
          );
        }
      } // end of 'startCreatingOrEditing'.
      // Auto Enter Form Fields:
      else if (activityType == FormActivityType.patchFormFields) {
        if (formInput != null && formInput is! EmptyFormInput) {
          executionTrace._addTraceStep(
            codeId: "#17600",
            shortDesc:
                "(In _loadMultiOptPropDataCascade() method for ${debugObjHtml(multiOptProp)}):",
            parameters: {
              "activityType": activityType,
              "currentItemDetail": currentItemDetail,
              "formInput": formInput,
            },
            lineFlowType: LineFlowType.debug,
          );
          // May throw FormTempError.
          initialValueWrap = __extractUpdateValueForMultiOptProp(
            executionTrace: executionTrace,
            additionalFormRelatedData: additionalFormRelatedData,
            formInput: formInput,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _formPropsStructure._getTempCurrentPropValue(
        propName: multiOptPropName,
      );
      //
      if (tempCurrentValue != null) {
        if (tempCurrentValue is List) {
          currentSelectedItems = tempCurrentValue.isEmpty //
              ? null
              : tempCurrentValue;
        } else {
          currentSelectedItems = [tempCurrentValue];
        }
      }
      if (currentSelectedItems != null) {
        currentSelectedItems =
            tempMultiOptPropXData._resolveItemsFromRawData(
          dynamicValues: currentSelectedItems,
          addOrphan: true,
          clearOrphanItems: true,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = initialValueWrap?.values;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    }
    // tempMultiOptPropXData == null
    else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    _formPropsStructure._setTempMultiOptPropXData(
      multiOptPropName: multiOptPropName,
      multiOptPropXData: tempMultiOptPropXData,
    );
    //
    final dynamic initialValue;
    if (activityType == FormActivityType.startCreatingOrEditing) {
      initialValue = initialValueWrap?.values;
    } else {
      initialValue = _formPropsStructure._getInitialPropValue(
        propName: multiOptPropName,
      );
    }
    //
    if (activityType == FormActivityType.startCreatingOrEditing ||
        parentValueIsInitialValue) {
      tempMultiOptPropXData?._addInitialValueIfOrphan(
        initialValue: initialValue,
        removeCurrentOrphanItems: true,
      );
    }
    // TODO: Dangerous, check not null:
    candidateSelectedItems =
        tempMultiOptPropXData?._resolveItemsFromRawData(
              dynamicValues: candidateSelectedItems,
              //
              // IMPORTANT: Add not found item to internal list.
              //
              addOrphan: true,
              clearOrphanItems: false,
            ) ??
            [];
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems.isNotEmpty) {
      if (multiOptProp.selectionType == SelectionType.single) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formPropsStructure._updatePropsTempValues({
          multiOptPropName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _formPropsStructure._updatePropsTempValues({
          multiOptPropName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({
        multiOptPropName: null,
      });
    }
    //
    Object? tempSelectedPropValue =
        _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );

    if (tempSelectedPropValue != null) {
      for (MultiOptFormPropModel child in multiOptProp._children) {
        await _loadMultiOptPropDataCascade(
          executionTrace: executionTrace,
          additionalFormRelatedData: additionalFormRelatedData,
          formInput: formInput,
          parentMultiOptPropValue: tempSelectedPropValue,
          parentValueIsInitialValue: multiOptValueIsInitialValue,
          multiOptProp: child,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Used for FormView.
  ///
  Map<String, dynamic> _initialValuesForFormView() {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getInitialPropValue(String propName) {
    return _formPropsStructure._getInitialPropValue(propName: propName);
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Add test case:
  @Deprecated("Xem lai, co can xoa di khong?")
  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    _formPropsStructure._setCurrentPropValue(
      propName: propertyName,
      value: value,
    );
    ui.updateAllUiComponents();
  }

  dynamic getPropValue(String propName) {
    return _formPropsStructure._getCurrentPropValue(
      propName: propName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptPropXData(String multiOptPropName) {
    return _formPropsStructure._getCurrentMultiOptPropXData(
      propName: multiOptPropName,
    );
  }

  dynamic getMultiOptPropData(String multiOptPropName) {
    return _formPropsStructure._getCurrentMultiOptPropData(
      propName: multiOptPropName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __specifyDefaultValueForMultiOptProp({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace._addTraceStep(
        codeId: "#33000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.specifyDefaultValueForMultiOptProp() for <b>'$multiOptPropName'</b>.",
        parameters: {
          "multiOptPropXData": multiOptPropXData,
          "multiOptPropName": multiOptPropName,
          "selectionType": selectionType,
          "parentMultiOptPropValue": parentMultiOptPropValue,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      OptValueWrap? valueWrap = specifyDefaultValueForMultiOptProp(
        multiOptPropXData: multiOptPropXData,
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "specifyDefaultValueForMultiOptProp",
          multiOptPropName: multiOptPropName,
        );
        return null;
      }
      List? value = valueWrap.values;
      return OptValueWrap.multi(
        multiOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.specifyDefaultValueForMultiOptProp,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppError({
    required String methodName,
    required String multiOptPropName,
  }) {
    MultiOptFormPropModel? multiOptProp =
        _formPropsStructure._getMultiOptFormProp(multiOptPropName);
    if (multiOptProp == null) {
      throw "The '$multiOptPropName' is not $MultiOptFormPropModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptPropName '$multiOptPropName'. ";
    if (multiOptProp.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptFormPropModel. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractMultiOptPropValueFromItemDetail({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      executionTrace._addTraceStep(
        codeId: "#32000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.extractMultiOptPropValueFromItemDetail() for <b>'$multiOptPropName'</b>.",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "selectionType": selectionType,
          "multiOptPropXData": multiOptPropXData,
          "itemDetail": itemDetail,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      OptValueWrap? valueWrap = extractMultiOptPropValueFromItemDetail(
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        multiOptPropXData: multiOptPropXData,
        additionalFormRelatedData: additionalFormRelatedData,
        itemDetail: itemDetail,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractMultiOptPropValueFromItemDetail",
          multiOptPropName: multiOptPropName,
        );
      }
      return valueWrap;
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.extractMultiOptPropValueFromItemDetail,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __extractUpdateValueForMultiOptProp({
    required ExecutionTrace executionTrace,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
    required FORM_INPUT formInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (formInput is EmptyFormInput) {
      return null;
    }
    try {
      executionTrace._addTraceStep(
        codeId: "#18000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.extractUpdateValueForMultiOptProp() for <b>'$multiOptPropName'</b>.",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "multiOptPropXData": multiOptPropXData,
          "selectionType": selectionType,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
          "additionalFormRelatedData": additionalFormRelatedData,
          "formInput": formInput,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      OptValueWrap? valueWrap = extractUpdateValueForMultiOptProp(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: multiOptPropXData,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        parentBlockCurrentItemId: block.parentBlockCurrentItemId,
        additionalFormRelatedData: additionalFormRelatedData,
        formInput: formInput,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "extractUpdateValueForMultiOptProp",
          multiOptPropName: multiOptPropName,
        );
      }
      List? value = valueWrap?.values ?? [];
      return OptValueWrap.multi(
        multiOptPropXData._resolveItemsFromRawData(
          dynamicValues: value,
          addOrphan: true,
          clearOrphanItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormMethodError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.extractUpdateValueForMultiOptProp,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isNew {
    return _formPropsStructure.isNew;
  }

  Map<String, dynamic> get initialFormData {
    return _formPropsStructure.initialFormData;
  }

  Map<String, dynamic> get currentFormData {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearDataWithDataState({required DataState formDataState}) {
    try {
      _formPropsStructure._clearFormDataWithState(
        formDataState: formDataState,
      );
      //
      this.__clearFormKey();
      //
      block.ui.updateControlBars();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_clearDataWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearFormKey() {
    final Map<String, dynamic> instantValues =
        this._formKey.currentState?.instantValue ?? {};
    //
    final Map<String, dynamic> newFormData = {...instantValues}
      ..updateAll((k, v) => null);
    this._formKey.currentState?.patchValue(newFormData);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _formPropsStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    Actionable<BlockFormEnablementPrecheckCode> actionable =
        block._isEnableFormToModify();
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  void resetForm() {
    Actionable canReset = block.canResetForm();
    if (canReset.no) {
      return;
    }
    try {
      _changeEventLocked = true;
      //
      // Reset FormData:
      //
      _formPropsStructure._resetFormData();
      //
      // Patch _formKey:
      //
      Map<String, dynamic> initData = {..._formPropsStructure.initialFormData};
      for (String key in _formKey.currentState?.instantValue.keys ?? []) {
        if (!initData.containsKey(key)) {
          initData[key] = null;
        }
      }
      _formKey.currentState?.patchValue(initData);
      //
      shelf.ui.updateAllUiComponents();
    } finally {
      _changeEventLocked = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  @_ImportantMethodAnnotation("Called when user makes a change in FormView.")
  @_FormViewChangeAnnotation()
  Future<void> _onChangeFromFormView() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromFormView");
    //
    final XShelf xShelf = _XShelfFormViewChange(formModel: this);
    //
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    XFormModel xFormModel = xBlock.xFormModel!;
    _FormViewChangeTaskUnit taskUnit = _FormViewChangeTaskUnit(
      xFormModel: xFormModel,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    //
    await FlutterArtist.executor._executeTaskUnitQueue(showOverlay: false);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFormView() {
    _formPropsStructure._justInitialized = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<PatchFormFieldsPrecheck> __canPatchFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<PatchFormFieldsPrecheck>.no(
        errCode: PatchFormFieldsPrecheck.busy,
      );
    }
    if (formMode == FormMode.none) {
      return Actionable<PatchFormFieldsPrecheck>.no(
        errCode: PatchFormFieldsPrecheck.formInNoneMode,
      );
    }
    if (dataState == DataState.error) {
      return Actionable<PatchFormFieldsPrecheck>.no(
        errCode: PatchFormFieldsPrecheck.formInErrorState,
      );
    }
    return Actionable<PatchFormFieldsPrecheck>.yes();
  }

  bool __checkBeforePatchFormFields({
    required bool checkBusy,
    required bool addErrorLog,
    required bool showErrSnackBar,
  }) {
    Actionable createActionable = __canPatchFormFields(
      checkBusy: checkBusy,
    );
    if (!createActionable.yes) {
      if (addErrorLog) {
        _addErrorLogActionable(
          shelf: shelf,
          actionableFalse: createActionable,
          showErrSnackBar: showErrSnackBar,
          tipDocument: null,
        );
      }
      return false;
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Test Case: [26a]
  @_RootMethodAnnotation()
  @_FormModelPatchFormFieldsAnnotation()
  Future<FormModelPatchFormFieldsResult> patchFormFields({
    required FORM_INPUT formInput,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "patchFormFields",
      parameters: {
        "formInput": formInput,
      },
      navigate: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#78000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canPatchFormFields() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    final Actionable<PatchFormFieldsPrecheck> actionable = __canPatchFormFields(
      checkBusy: checkBusyTrue,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#78040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        lineFlowType: LineFlowType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormModelPatchFormFieldsResult(
        precheck: actionable.errCode,
      );
    }
    //
    final XShelf xShelf = _XShelfFormModelPatchFormFields(formModel: this);
    //
    XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    XFormModel xFormModel = xBlock.xFormModel!;
    //
    executionTrace._addTraceStep(
      codeId: "#78340",
      shortDesc: "Creating <b>_FormModelPatchFormFieldsTaskUnit</b>.",
      lineFlowType: LineFlowType.addTaskUnit,
    );
    _ResultedSTaskUnit taskUnit = _FormModelPatchFormFieldsTaskUnit(
      xFormModel: xFormModel,
      formInput: formInput,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_FormModelSaveFormAnnotation()
  Future<FormSaveResult> saveForm() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    final bool checkValidateTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#79000",
      shortDesc:
          "Calling ${debugObjHtml(block)}.__canSaveForm() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "checkValidate": checkValidateTrue,
      },
    );
    //
    Actionable<BlockFormSavePrecheck> actionable = block.__canSaveForm(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      checkValidate: checkValidateTrue,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#79040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        lineFlowType: LineFlowType.debug,
      );
      //
      _saveErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FormSaveResult(precheck: actionable.errCode);
    }
    //
    final XShelf xShelf = _XShelfFormModelSave(formModel: this);
    //
    XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    XFormModel xFormModel = xBlock.xFormModel!;
    //
    executionTrace._addTraceStep(
      codeId: "#79340",
      shortDesc: "Creating <b>_FormModelSaveFormTaskUnit</b>.",
      lineFlowType: LineFlowType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _FormModelSaveFormTaskUnit(
      xFormModel: xFormModel,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFormModelViewerDialog() async {
    BuildContext context = FlutterArtist.coreFeaturesAdapter.context;
    //
    await DebugFormModelViewerDialog.open(
      context: context,
      locationInfo: getClassName(this),
      formModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (filter)
  MultiOptFormPropModel? findMultiOptFormProp({
    required String multiOptPropName,
  }) {
    return _formPropsStructure._findMultiOptFormProp(
      multiOptPropName,
    );
  }

  // SAME-AS: #0008 (filterModel.debugGetMultiOptCriterionLoadCount())
  int debugGetMultiOptPropLoadCount(String multiOptPropName) {
    return _formPropsStructure._debugGetMultiOptPropLoadCount(
      multiOptPropName: multiOptPropName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFormModel(XFormModel thisXFormModel) {
    if (!identical(thisXFormModel.formModel, this)) {
      String message =
          "Error Assert form model: ${thisXFormModel.formModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
