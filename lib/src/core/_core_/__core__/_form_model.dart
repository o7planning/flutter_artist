part of '../core.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Identifiable<ID>,
    FORM_INPUT extends FormInput,
    FORM_RELATED_DATA extends FormRelatedData // EmptyFormRelatedData
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

  FORM_RELATED_DATA? __formRelatedData;
  FORM_INPUT? __creationFormInput;

  bool _changeEventLocked = false;

  bool _loadTimeUIActive = false;

  bool get loadTimeUIActive => _loadTimeUIActive;

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
      FORM_RELATED_DATA> block;

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

  late final ui = _FormUIComponents(formModel: this);

  // ***************************************************************************

  late final FormPropsStructure _formPropsStructure;

  FormPropsStructure get formPropsStructure => _formPropsStructure;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // ***************************************************************************
  // ***************************************************************************

  FormModel({
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormModelConfig config = const FormModelConfig(),
  })  : config = config.copy(),
        _autovalidateMode = config.autovalidateMode {
    __registerPropsStructure();
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
  /// FormPropsStructure registerPropsStructure() {
  ///   return FormPropsStructure(
  ///     simpleProps: [],
  ///     multiOptProps: [
  ///       // Multi Options Single Selection Property.
  ///       MultiOptSsProp(
  ///         propName: "company",
  ///         children: [
  ///           // Multi Options Multi Selections Property.
  ///           MultiOptMsProp(
  ///              propName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FormPropsStructure registerPropsStructure();

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
  /// Case FormActivityType.enterFormFields:
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
  Future<XData?> callApiLoadMultiOptPropXData({
    required String multiOptPropName,
    required SelectionType selectionType,
    required Object? parentMultiOptPropValue,
    required FORM_RELATED_DATA formRelatedData,
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
  // SAME-AS: #0011 (filter - specifyDefaultValuesForSimpleCriteria)
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForSimpleProps({
    required Object? parentBlockCurrentItemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required FORM_RELATED_DATA formRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// [itemDetail] should include the ID of the parent Block's currentItem.
  /// Let's look at an example with class [DepartmentFormModel]:
  /// ```dart
  ///  Map<String, dynamic>? getSimplePropValuesFromItemDetail({
  ///      required Object? parentBlockCurrentItemId,
  ///      required EmptyFormRelatedData formRelatedData,
  ///      required DepartmentData itemDetail,
  ///  }) {
  ///     return {
  ///        "companyId": itemDetail.companyId,
  ///        "departmentName": itemDetail.name,
  ///     };
  ///  }
  /// ```
  ///
  /// [formRelatedData] can include other information from the parent Block's [currentItem].
  /// ```dart
  ///  Map<String, dynamic>? getSimplePropValuesFromItemDetail({
  ///      required Object? parentBlockCurrentItemId,
  ///      required DepartmentFormRelatedData formRelatedData,
  ///      required DepartmentData itemDetail,
  ///  }) {
  ///     return {
  ///        "companyId": itemDetail.companyId,
  ///        "companyName": formRelatedData.companyName,
  ///        "departmentName": itemDetail.name,
  ///     };
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? getSimplePropValuesFromItemDetail({
    required Object? parentBlockCurrentItemId,
    required FORM_RELATED_DATA formRelatedData,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  // OLD: getMultiOptPropValueFromFormInput.
  @_AbstractMethodAnnotation()
  OptValueWrap? getUpdatedValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required Object? parentBlockCurrentItemId,
    required FORM_RELATED_DATA formRelatedData,
    required FORM_INPUT formInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  /// ```dart
  ///  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleProps({
  ///     required Object? parentBlockCurrentItemId,
  ///     required FORM_RELATED_DATA formRelatedData,
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
  // OLD: getUpdatedValuesForSimpleProps.
  // SAME-AS: #0010 (filter - getUpdatedValuesForSimpleCriteria)
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleProps({
    required Object? parentBlockCurrentItemId,
    required FORM_RELATED_DATA formRelatedData,
    required FORM_INPUT formInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
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

  void showFormErrorViewerDialog(BuildContext context) {
    if (dataState != DataState.error) {
      return;
    }
    FormErrorViewerDialog.showFormErrorViewerDialog(
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
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFormModel xFormModel,
  }) async {
    __assertThisXFormModel(xFormModel);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#36000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    await _startNewFormActivity(
      masterFlowItem: masterFlowItem,
      formRelatedData: null,
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
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFormModel thisXFormModel,
    required FormModelDataLoadResult taskResult,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    masterFlowItem._addLineFlowItem(
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
        //     formDataState != DataState.ready && hasActiveUIComponent();
        forceReloadForm = false;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#37060",
      shortDesc:
          "Calculate >>  @forceReloadForm: ${debugObjHtml(forceReloadForm)}",
    );
    //
    if (!forceReloadForm) {
      if (dataState != DataState.ready) {
        masterFlowItem._addLineFlowItem(
          codeId: "#37100",
          shortDesc:
              "${debugObjHtml(this)} - @dataState: ${debugObjHtml(dataState)} --> Clear data and set to <b>pending</b>.",
        );
        _clearDataWithDataState(formDataState: DataState.pending);
      }
      masterFlowItem._addLineFlowItem(
        codeId: "#37120",
        shortDesc:
            "@forceReloadForm: ${debugObjHtml(forceReloadForm)} --> do nothing.",
      );
      return true;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#37160",
      shortDesc: "Calling ${debugObjHtml(block)}._initFormRelatedData().",
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    FORM_RELATED_DATA? formRelatedData =
        await block._initFormRelatedData(masterFlowItem);
    if (formRelatedData == null) {
      return false;
    }
    //
    final formInput = thisXFormModel.formInput as FORM_INPUT?;
    final activityType = FormActivityType.startCreatingOrEditing;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#37260",
      shortDesc: "Calling ${debugObjHtml(this)}._startNewFormActivity().",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
        "formRelatedData": formRelatedData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    // TODO: Bắt lỗi cho vào "taskResult" ???????
    return await _startNewFormActivity(
      masterFlowItem: masterFlowItem,
      formRelatedData: formRelatedData,
      formInput: formInput,
      activityType: activityType,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelEnterFormFieldsAnnotation()
  Future<bool> _unitEnterFormFields({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFormModel thisXFormModel,
    required FORM_INPUT formInput,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#38000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    final FORM_RELATED_DATA? formRelatedData = null;
    final activityType = FormActivityType.autoEnterFormFields;

    masterFlowItem._addLineFlowItem(
      codeId: "#38100",
      shortDesc: "Calling ${debugObjHtml(this)}._startNewFormActivity().",
      parameters: {
        "activityType": activityType,
        "formInput": formInput,
        "formRelatedData": formRelatedData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    //
    await _startNewFormActivity(
      masterFlowItem: masterFlowItem,
      formRelatedData: formRelatedData, // null
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
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFormModel<ID, ITEM_DETAIL> thisXFormModel,
    required FormSaveResult taskResult,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    masterFlowItem._addLineFlowItem(
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
        ? 'callApiCreateItem'
        : 'callApiUpdateItem';
    //
    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
    final bool isNew = _formPropsStructure.isNew;
    try {
      // FlutterArtist.codeFlowLogger._addMethodCall(
      //   isLibCode: false,
      //   ownerClassInstance: this,
      //   methodName: calledMethodName,
      //   parameters: {
      //     "formMapData": formMapData,
      //   },
      //   navigate: null,
      // );
      //
      block._refreshSavingState(isSaving: true);
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#11400",
        shortDesc: "Calling ${debugObjHtml(this)}.$calledMethodName()...",
        parameters: {
          "formMapData": formMapData,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      //
      result = isNew
          ? await callApiCreateItem(formMapData: formMapData)
          : await callApiUpdateItem(formMapData: formMapData);
    } catch (e, stackTrace) {
      saveError = true;
      //
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      masterFlowItem._addLineFlowItem(
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
      masterFlowItem._addLineFlowItem(
        codeId: "#11800",
        shortDesc:
            "Calling ${debugObjHtml(this)}._processSaveActionRestResult().",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      await block._processSaveActionRestResult(
        masterFlowItem: masterFlowItem,
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
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      masterFlowItem._addLineFlowItem(
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

  void __registerPropsStructure() {
    try {
      _formPropsStructure = registerPropsStructure();
      _formPropsStructure.formModel = this;
    } on DuplicateFormPropError catch (e) {
      String message =
          "Duplicate prop '${e.propName}' in ${getClassName(this)}";
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
    required MasterFlowItem masterFlowItem,
    required FORM_RELATED_DATA? formRelatedData,
    required FORM_INPUT? formInput,
    required FormActivityType activityType,
  }) async {
    __formActivityCount++;
    //
    masterFlowItem._addLineFlowItem(
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
        if (formRelatedData == null) {
          throw DevError(
            errorMessage:
                "Dev Error. formRelatedData must be not null if FormModel.activityType = startCreatingOrEditing.",
          );
        }
        __formRelatedData = formRelatedData;
      case FormActivityType.updateFromFormView:
        currentFormMode = formMode;
        if (formRelatedData != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formRelatedData must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        formRelatedData = __formRelatedData!;
        if (formInput != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formInput must be null if FormModel.activityType = updateFromFormView.",
          );
        }
        if (currentFormMode == FormMode.creation) {
          formInput = __creationFormInput;
        }
      case FormActivityType.autoEnterFormFields:
        currentFormMode = formMode;
        if (formRelatedData != null) {
          throw DevError(
            errorMessage:
                "Dev Error. formRelatedData must be null if FormModel.activityType = autoEnterFormFields.",
          );
        }
        formRelatedData = __formRelatedData!;
        if (formInput == null) {
          throw DevError(
            errorMessage:
                "Dev Error. formInput must be not null if FormModel.activityType = autoEnterFormFields.",
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
    _formPropsStructure._initTemporaryForNewActivity(
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
        masterFlowItem._addLineFlowItem(
          codeId: "#06180",
          shortDesc: "Editing item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
          lineFlowType: LineFlowType.debug,
        );
        try {
          masterFlowItem._addLineFlowItem(
            codeId: "#06200",
            lineFlowType: LineFlowType.controllableCalling,
            shortDesc:
                "Calling ${debugObjHtml(this)}.getSimplePropValuesFromItemDetail().",
            parameters: {
              "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
              "itemDetail": itemDetail,
              "formRelatedData": formRelatedData,
            },
          );
          var simplePropValueMap = getSimplePropValuesFromItemDetail(
                parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                formRelatedData: formRelatedData,
                itemDetail: itemDetail,
              ) ??
              {};
          for (String propName in simplePropValueMap.keys) {
            // Check and throw error if 'propName' is not a SimpleFormProp:
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod:
                  FormErrorMethod.getSimplePropValuesFromItemDetail,
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
          final formErrorInfo = FormErrorInfo(
            activityType: activityType,
            propName: null,
            formErrorMethod: FormErrorMethod.getSimplePropValuesFromItemDetail,
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
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          masterFlowItem._addLineFlowItem(
            codeId: "#06400",
            shortDesc:
                "The ${debugObjHtml(this)}.getSimplePropValuesFromItemDetail() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
      // itemDetail == null. [[Currently Condition: startCreatingOrEditing && itemDetail == null]].
      else {
        masterFlowItem._addLineFlowItem(
          codeId: "#06500",
          shortDesc: "Creating item in the form."
              "\n - @activityType: <b>$activityType</b>."
              "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
          lineFlowType: LineFlowType.debug,
        );
        Map<String, dynamic> simplePropValueDefault = {};
        if (!_defaultSimpleValuesInitiated) {
          masterFlowItem._addLineFlowItem(
            codeId: "#06520",
            shortDesc:
                "@_defaultSimpleValuesInitiated = false --> Need to init default simple values.",
          );
          try {
            masterFlowItem._addLineFlowItem(
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
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              activityType: activityType,
              error: e,
            );
            masterFlowItem._addLineFlowItem(
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
        formInput ??= block.__initInputForCreationForm(masterFlowItem);
        if (formInput != null) {
          try {
            masterFlowItem._addLineFlowItem(
              codeId: "#06620",
              shortDesc:
                  "Calling ${debugObjHtml(this)}.getUpdatedValuesForSimpleProps().",
              parameters: {
                "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
                "formInput": formInput,
                "formRelatedData": formRelatedData,
              },
              lineFlowType: LineFlowType.controllableCalling,
            );
            final Map<String, SimpleValueWrap?> updatedSimplePropValues =
                getUpdatedValuesForSimpleProps(
                      parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                      formRelatedData: formRelatedData,
                      formInput: formInput!,
                    ) ??
                    {};
            //
            for (String propName in updatedSimplePropValues.keys) {
              // Check and throw error if 'propName' is not a SimpleFormProp:
              __throwErrorIfNotASimplePropName(
                propName: propName,
                formErrorMethod: FormErrorMethod.getUpdatedValuesForSimpleProps,
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
              formErrorMethod: FormErrorMethod.getUpdatedValuesForSimpleProps,
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
            );
            //
            __endFormActivityWithDataState(
              formDataState: DataState.error,
              error: e,
              activityType: activityType,
            );
            //
            masterFlowItem._addLineFlowItem(
              codeId: "#06660",
              shortDesc:
                  "The ${debugObjHtml(this)}.getUpdatedValuesForSimpleProps() method was called with an error!",
              errorInfo: errorInfo,
            );
            return false;
          }
        }
      }
    } // end of "startCreatingOrEditing".
    // Begin of 'autoEnterFormFields'.
    else if (activityType == FormActivityType.autoEnterFormFields) {
      masterFlowItem._addLineFlowItem(
        codeId: "#06700",
        shortDesc: "Enter Form Fields."
            "\n - @activityType: <b>$activityType</b>."
            "\n - @itemDetail: ${debugObjHtml(itemDetail)}.",
        lineFlowType: LineFlowType.debug,
      );
      if (formInput != null) {
        try {
          masterFlowItem._addLineFlowItem(
            codeId: "#06720",
            shortDesc:
                "Calling ${debugObjHtml(this)}.getUpdatedValuesForSimpleProps() with parameters:",
            parameters: {
              "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
              "formInput": formInput,
              "formRelatedData": formRelatedData,
            },
            lineFlowType: LineFlowType.controllableCalling,
          );
          final Map<String, SimpleValueWrap?> updatedSimplePropValues =
              getUpdatedValuesForSimpleProps(
                    parentBlockCurrentItemId: block.parentBlockCurrentItemId,
                    formRelatedData: formRelatedData,
                    formInput: formInput,
                  ) ??
                  {};
          //
          for (String propName in updatedSimplePropValues.keys) {
            // Check and throw error if 'propName' is not a SimpleFormProp:
            __throwErrorIfNotASimplePropName(
              propName: propName,
              formErrorMethod: FormErrorMethod.getUpdatedValuesForSimpleProps,
            );
            //
            // In (autoEnterFormFields + formInput != null)
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
            formErrorMethod: FormErrorMethod.getUpdatedValuesForSimpleProps,
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
          );
          //
          __endFormActivityWithDataState(
            formDataState: DataState.error,
            activityType: activityType,
            error: e,
          );
          masterFlowItem._addLineFlowItem(
            codeId: "#06760",
            shortDesc:
                "The ${debugObjHtml(this)}.getUpdatedValuesForSimpleProps() method was called with an error!",
            errorInfo: errorInfo,
          );
          return false;
        }
      }
    } // End of 'autoEnterFormFields'.
    //
    // Load MultiOptProp Data (All cases of activityType).
    //
    try {
      for (MultiOptFormProp multiOptProp in _formPropsStructure._rootOptProps) {
        masterFlowItem._addLineFlowItem(
          codeId: "#06780",
          shortDesc:
              "Calling ${debugObjHtml(this)}._loadMultiOptPropDataCascade() "
              "to load data for ${debugObjHtml(multiOptProp)} and its descendants.",
          parameters: {
            "formRelatedData": formRelatedData,
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
          masterFlowItem: masterFlowItem,
          formRelatedData: formRelatedData,
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
      if (e is FormTempError) {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: e.propName,
          formErrorMethod: e.formErrorMethod,
          error: e.error,
          errorStackTrace: e.stackTrace,
        );
        _formPropsStructure._setFormError(formErrorInfo);
      } else {
        formErrorInfo = FormErrorInfo(
          activityType: activityType,
          propName: null,
          formErrorMethod: FormErrorMethod.unknown,
          error: e,
          errorStackTrace: stackTrace,
        );
        _formPropsStructure._setFormError(formErrorInfo);
      }
      //
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: formErrorInfo.methodName,
        error: formErrorInfo.error,
        stackTrace: formErrorInfo.errorStackTrace,
        showSnackBar: true,
      );
      //
      __endFormActivityWithDataState(
        formDataState: DataState.error,
        activityType: activityType,
        error: e,
      );
      masterFlowItem._addLineFlowItem(
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
            '$propName is not a ${getTypeNameWithoutGenerics(SimpleFormProp)}',
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
    required final MasterFlowItem masterFlowItem,
    required final FormActivityType activityType,
    required final FORM_RELATED_DATA formRelatedData,
    required final FORM_INPUT? formInput,
    required final Object? parentMultiOptPropValue,
    required final MultiOptFormProp multiOptProp,
    required final bool parentValueIsInitialValue,
    required final Map<String, dynamic> formKeyInstantValues,
  }) async {
    final String multiOptPropName = multiOptProp.propName;
    final SelectionType selectionType = multiOptProp.selectionType;

    masterFlowItem._addLineFlowItem(
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
      masterFlowItem._addLineFlowItem(
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
        masterFlowItem._addLineFlowItem(
          codeId: "#17400",
          shortDesc:
              "Calling ${debugObjHtml(this)}.callApiLoadMultiOptPropXData().",
          parameters: {
            "multiOptPropName": multiOptPropName,
            "parentMultiOptPropValue": parentMultiOptPropValue,
            "selectionType": selectionType,
            "itemDetail": block.currentItemDetail,
            "formInput": formInput,
            "formRelatedData": formRelatedData,
          },
          lineFlowType: LineFlowType.controllableCalling,
        );
        // May throw AppError, ApiError or others.
        tempMultiOptPropXData = await callApiLoadMultiOptPropXData(
          formInput: formInput,
          itemDetail: block.currentItemDetail,
          formRelatedData: formRelatedData,
          parentMultiOptPropValue: parentMultiOptPropValue,
          multiOptPropName: multiOptPropName,
          selectionType: selectionType,
        );
      } catch (e, stackTrace) {
        throw FormTempError(
          propName: multiOptPropName,
          formErrorMethod: FormErrorMethod.callApiLoadMultiOptPropXData,
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
          masterFlowItem._addLineFlowItem(
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
              masterFlowItem: masterFlowItem,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              multiOptPropXData: tempMultiOptPropXData,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            masterFlowItem._addLineFlowItem(
              codeId: "#17540",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
            );
          }
          if (formInput != null && formInput is! EmptyFormInput) {
            // May throw FormTempError.
            initialValueWrap = __getUpdatedValueForMultiOptProp(
              masterFlowItem: masterFlowItem,
              formRelatedData: formRelatedData,
              formInput: formInput,
              multiOptPropXData: tempMultiOptPropXData,
              multiOptPropName: multiOptPropName,
              selectionType: selectionType,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
            masterFlowItem._addLineFlowItem(
              codeId: "#17560",
              shortDesc: "Got Value: ${debugObjHtml(initialValueWrap)}.",
            );
          }
        }
        // currentItemDetail != null
        else {
          masterFlowItem._addLineFlowItem(
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
          initialValueWrap = __getMultiOptPropValueFromItemDetail(
            masterFlowItem: masterFlowItem,
            formRelatedData: formRelatedData,
            itemDetail: currentItemDetail,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            selectionType: selectionType,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
          masterFlowItem._addLineFlowItem(
            codeId: "#17590",
            shortDesc: "Got value: ${debugObjHtml(initialValueWrap)}",
          );
        }
      } // end of 'startCreatingOrEditing'.
      // Auto Enter Form Fields:
      else if (activityType == FormActivityType.autoEnterFormFields) {
        if (formInput != null && formInput is! EmptyFormInput) {
          masterFlowItem._addLineFlowItem(
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
          initialValueWrap = __getUpdatedValueForMultiOptProp(
            masterFlowItem: masterFlowItem,
            formRelatedData: formRelatedData,
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
            tempMultiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
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
      tempMultiOptPropXData?._addInitialValueIfNotFound(
        initialValue: initialValue,
        removeCurrentNotFoundItems: true,
      );
    }
    // TODO: Dangerous, check not null:
    candidateSelectedItems =
        tempMultiOptPropXData?._findInternalItemsByDynamics(
              dynamicValues: candidateSelectedItems,
              //
              // IMPORTANT: Add not found item to internal list.
              //
              addToInternalIfNotFound: true,
              removeCurrentNotFoundItems: false,
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
      for (MultiOptFormProp child in multiOptProp._children) {
        await _loadMultiOptPropDataCascade(
          masterFlowItem: masterFlowItem,
          formRelatedData: formRelatedData,
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
    ui.updateAllUIComponents();
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
    required MasterFlowItem masterFlowItem,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      masterFlowItem._addLineFlowItem(
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
        multiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: value,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormTempError(
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
    MultiOptFormProp? multiOptProp =
        _formPropsStructure._getMultiOptFormProp(multiOptPropName);
    if (multiOptProp == null) {
      throw "The '$multiOptPropName' is not $MultiOptFormProp";
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
        "And return null for not $MultiOptFormProp. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __getMultiOptPropValueFromItemDetail({
    required MasterFlowItem masterFlowItem,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required FORM_RELATED_DATA formRelatedData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  }) {
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#32000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.getMultiOptPropValueFromItemDetail() for <b>'$multiOptPropName'</b>.",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "selectionType": selectionType,
          "multiOptPropXData": multiOptPropXData,
          "itemDetail": itemDetail,
          "formRelatedData": formRelatedData,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      OptValueWrap? valueWrap = getMultiOptPropValueFromItemDetail(
        multiOptPropName: multiOptPropName,
        selectionType: selectionType,
        multiOptPropXData: multiOptPropXData,
        formRelatedData: formRelatedData,
        itemDetail: itemDetail,
        parentMultiOptPropValue: parentMultiOptPropValue,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "getMultiOptPropValueFromItemDetail",
          multiOptPropName: multiOptPropName,
        );
      }
      return valueWrap;
    } catch (e, stackTrace) {
      throw FormTempError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.getMultiOptPropValueFromItemDetail,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_MayThrowFormTempErrorAnnotation()
  OptValueWrap? __getUpdatedValueForMultiOptProp({
    required MasterFlowItem masterFlowItem,
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required FORM_RELATED_DATA formRelatedData,
    required FORM_INPUT formInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (formInput is EmptyFormInput) {
      return null;
    }
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#18000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.getUpdatedValueForMultiOptProp() for <b>'$multiOptPropName'</b>.",
        parameters: {
          "multiOptPropName": multiOptPropName,
          "multiOptPropXData": multiOptPropXData,
          "selectionType": selectionType,
          "parentMultiOptPropValue": parentMultiOptPropValue,
          "parentBlockCurrentItemId": block.parentBlockCurrentItemId,
          "formRelatedData": formRelatedData,
          "formInput": formInput,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      OptValueWrap? valueWrap = getUpdatedValueForMultiOptProp(
        multiOptPropName: multiOptPropName,
        multiOptPropXData: multiOptPropXData,
        selectionType: selectionType,
        parentMultiOptPropValue: parentMultiOptPropValue,
        parentBlockCurrentItemId: block.parentBlockCurrentItemId,
        formRelatedData: formRelatedData,
        formInput: formInput,
      );
      if (valueWrap == null) {
        __createNullValueWrapAppError(
          methodName: "getUpdatedValueForMultiOptProp",
          multiOptPropName: multiOptPropName,
        );
      }
      List? value = valueWrap?.values ?? [];
      return OptValueWrap.multi(
        multiOptPropXData._findInternalItemsByDynamics(
          dynamicValues: value,
          addToInternalIfNotFound: true,
          removeCurrentNotFoundItems: true,
        ),
      );
    } catch (e, stackTrace) {
      throw FormTempError(
        propName: multiOptPropName,
        formErrorMethod: FormErrorMethod.getUpdatedValueForMultiOptProp,
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
      block.ui.updateControlBarWidgets();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_clearDataWithDataState",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
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
      shelf.ui.updateAllUIComponents();
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

  Actionable<EnterFormFieldsPrecheck> __canEnterFormFields({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<EnterFormFieldsPrecheck>.no(
        errCode: EnterFormFieldsPrecheck.busy,
      );
    }
    if (formMode == FormMode.none) {
      return Actionable<EnterFormFieldsPrecheck>.no(
        errCode: EnterFormFieldsPrecheck.formInNoneMode,
      );
    }
    if (dataState == DataState.error) {
      return Actionable<EnterFormFieldsPrecheck>.no(
        errCode: EnterFormFieldsPrecheck.formInErrorState,
      );
    }
    return Actionable<EnterFormFieldsPrecheck>.yes();
  }

  bool __checkBeforeEnterFormFields({
    required bool checkBusy,
    required bool addErrorLog,
    required bool showErrSnackBar,
  }) {
    Actionable createActionable = __canEnterFormFields(
      checkBusy: checkBusy,
    );
    if (!createActionable.yes) {
      if (addErrorLog) {
        _addErrorLogActionable(
          shelf: shelf,
          actionableFalse: createActionable,
          showErrSnackBar: showErrSnackBar,
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
  @_FormModelEnterFormFieldsAnnotation()
  Future<bool> enterFormFields({
    required FORM_INPUT formInput,
  }) async {
    // FlutterArtist.codeFlowLogger._addMethodCall(
    //   isLibCode: true,
    //   ownerClassInstance: this,
    //   methodName: "enterFormFields",
    //   parameters: {"formInput": formInput},
    //   navigate: null,
    // );
    //
    if (!__checkBeforeEnterFormFields(
      checkBusy: true,
      addErrorLog: true,
      showErrSnackBar: true,
    )) {
      return false;
    }
    //
    final XShelf xShelf = _XShelfFormModelEnterFields(formModel: this);
    //
    XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    XFormModel xFormModel = xBlock.xFormModel!;
    _STaskUnit taskUnit = _FormModelAutoEnterFormFieldsTaskUnit(
      xFormModel: xFormModel,
      formInput: formInput,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_FormModelSaveFormAnnotation()
  Future<FormSaveResult> saveForm() async {
    // FlutterArtist.codeFlowLogger._addMethodCall(
    //   isLibCode: true,
    //   ownerClassInstance: this,
    //   methodName: "saveForm",
    //   parameters: {},
    //   navigate: null,
    // );
    //
    Actionable<BlockFormSavePrecheck> actionable = block.__canSaveForm(
      checkBusy: true,
      checkAllow: true,
      checkValidate: true,
    );
    if (!actionable.yes) {
      _saveErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return FormSaveResult(precheck: actionable.errCode);
    }
    //
    final XShelf xShelf = _XShelfFormModelSave(formModel: this);
    //
    XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    XFormModel xFormModel = xBlock.xFormModel!;
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

  // SAME-AS: #0009 (filter)
  MultiOptFormProp? findMultiOptFormProp({
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
