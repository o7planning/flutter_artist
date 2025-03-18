part of '../flutter_artist.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> extends _XBase {
  QueryMode _queryMode = QueryMode.lazy;

  late QueryMode _tempQueryMode = _queryMode;

  int __loadCount = 0;

  int get loadCount => __loadCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get id {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  late final FormModelData data = FormModelData(formModel: this);

  FormMode get formMode => data.formMode;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Object,
      ITEM_DETAIL,
      FilterInput,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  DataState get dataState => data._dataState;

  QueryMode get queryMode => _queryMode;

  QueryMode get temporaryQueryMode => _tempQueryMode;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _defaultAutovalidateMode = AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  final Map<_RefreshableWidgetState, _XState> _formWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  FormModel();

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState formDataState}) {
    try {
      this.data._clearWithDataState(
            formDataState: formDataState,
          );
      //
      this.__clearFormKey();
      //
      updateAllUIComponents(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_clearWithDataState",
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

  Future<bool> _unitLoadForm({required _XFormModel thisXFormModel}) async {
    __assertThisXFormModel(thisXFormModel);
    //
    bool active = this.hasActiveUIComponent();
    bool forceForm = thisXFormModel.forceForm;
    //

    if (!forceForm) {
      if (!active) {
        if (this.dataState == DataState.error ||
            this.dataState == DataState.pending) {
          _clearWithDataState(formDataState: this.dataState);
          return true;
        } else {
          return true;
        }
      } else {
        if (this.dataState == DataState.error ||
            this.dataState == DataState.pending) {
          forceForm = true;
        } else {
          return true;
        }
      }
    }
    //
    // forceForm = true
    //
    __loadCount++;
    print(
        "@ ~~~~~~~~~~~~~~~~> ${getClassName(this)}._unitLoadForm - LOAD - $__loadCount");
    //
    ITEM_DETAIL? refreshedItemDetail = this.block.data.currentItemDetail;
    FILTER_CRITERIA? filterCriteria = this.block.data.filterCriteria;
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    bool isNew = this.data.isNew;
    //
    bool error = await _prepareMasterDataAndFormData(
      extraFormInput: extraFormInput,
      filterCriteria: filterCriteria,
      refreshedItemDetail: refreshedItemDetail,
      isNew: isNew,
    );
    //
    return error;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitSaveForm({required _XFormModel thisXFormModel}) async {
    if (!__checkValidBeforeSave()) {
      return false;
    }
    Map<String, dynamic> formMapData = data.currentFormData;
    //
    String calledMethodName = data.isNew //
        ? 'callApiCreateItem'
        : 'callApiUpdateItem';
    //
    ApiResult<ITEM_DETAIL> result;
    bool saveError = false;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        ownerClassInstance: this,
        methodName: calledMethodName,
        parameters: {
          "formMapData": formMapData,
        },
        navigate: null,
      );
      //
      block._refreshSavingState(isSaving: true);
      //
      result = data.isNew
          ? await callApiCreateItem(formMapData: formMapData)
          : await callApiUpdateItem(formMapData: formMapData);
      //
      block._refreshSavingState(isSaving: false);
    } catch (e, stackTrace) {
      saveError = true;
      block._refreshSavingState(isSaving: false);
      //
      _handleError(
        shelf: shelf,
        methodName: calledMethodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    try {
      return await block._processSaveActionRestResult(
        thisXBlock: thisXFormModel.xBlock,
        calledMethodName: calledMethodName,
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '_processSaveActionRestResult',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _prepareMasterDataAndFormData({
    required EXTRA_FORM_INPUT? extraFormInput,
    required FILTER_CRITERIA? filterCriteria,
    required ITEM_DETAIL? refreshedItemDetail,
    required bool isNew,
  }) async {
    print(">>> ${getClassName(this)}._prepareMasterDataAndFormData()");
    bool error = false;
    try {
      //
      // May throw ApiError.
      //
      await prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItemDetail,
        isNew: isNew,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormMasterData",
        error: "Error prepareFormMasterData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
    //
    Map<String, dynamic> newFormData = {};
    try {
      newFormData = prepareFormData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItemDetail,
        isNew: isNew,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormData",
        error: "Error prepareFormData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      error = true;
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
    //
    try {
      this.data._updateFormData(newFormData);
      this._formKey.currentState?.patchValue(newFormData);
      //
      this.data._setCurrentItem(
            refreshedItemDetail: refreshedItemDetail,
            formMode: isNew //
                ? FormMode.creation
                : FormMode.edit,
            dataState: DataState.ready,
          );
      //
      updateAllUIComponents(); // TODO: Xu ly loi?
      this.block.updateControlBarWidgets();
      return true;
    } catch (e, stackTrace) {
      error = true;
      //
      _handleError(
        shelf: shelf,
        methodName: "_updateFormData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
    }
    //
    if (error) {
      this.data._clearWithDataState(
            formDataState: DataState.error,
          );
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFormWidgetState({
    required _RefreshableWidgetState widgetState,
    required final bool isShowing,
  }) {
    bool isShowingOLD = _formWidgetStates[widgetState]?.isShowing ?? false;
    _formWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    if (!isShowingOLD && isShowing) {
      block.shelf._startNewLazyQueryTransactionIfNeed();
    }
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFormWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _formWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({bool force = false}) {
    __updateFormWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to refresh Widgets..
  ///
  void __updateFormWidgets({bool force = false}) {
    List<_RefreshableWidgetState> list = _getMountedFormWidgetStates();
    for (_RefreshableWidgetState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_RefreshableWidgetState> _getMountedFormWidgetStates() {
    List<_RefreshableWidgetState> ret = [];
    for (_RefreshableWidgetState widgetState in [..._formWidgetStates.keys]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _formWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    for (State formWidgetState in _formWidgetStates.keys) {
      bool visible = _formWidgetStates[formWidgetState]?.isShowing ?? false;
      if (visible && formWidgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return data._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    return block._isEnableFormToModify();
  }

  // ***************************************************************************
  // ***************************************************************************

  void resetForm() {
    Map<String, dynamic> initData = {...data._initialFormData};
    for (String key in _formKey.currentState?.instantValue.keys ?? []) {
      if (!initData.containsKey(key)) {
        initData[key] = null;
      }
    }
    _formKey.currentState?.patchValue(initData);
    //
    shelf.updateAllUIComponents();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  void _onChangeFromFormWidget() {
    if (_formKey.currentState?.instantValue != null) {
      data._currentFormData.addAll(_formKey.currentState!.instantValue);
      if (data._justInitialized) {
        data._initialFormData.addAll(_formKey.currentState!.instantValue);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFormView() {
    data._justInitialized = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFormValue() {
    return data._currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInstantValue(String propertyName) {
    return data._currentFormData[propertyName];
  }

  // ***************************************************************************
  // ***************************************************************************

  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    data._currentFormData[propertyName] = value;
    this.updateAllUIComponents();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to initialize the necessary data for the Form.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [prepareFormData] method.
  ///
  /// Example:
  /// ```dart
  /// Future<void> prepareFormMasterData({
  ///     required EmptyFilterCriteria? filterCriteria,
  ///     required EmptyExtraFormInput? extraFormInput,
  ///     required EmployeeData? refreshedItem,
  ///     required bool isNew,
  /// }) {
  ///   ApiResult<CompanyPage> result1 = await companyApi.getCompanyPage();
  ///   // Throw ApiError
  ///   result1.throwIfError();
  ///   this.companyPage = result1.data;
  ///   CompanyInfo? company = this.companyPage.getSelectedCompany()
  ///
  ///   ApiResult<DepartmentPage> result2 = await deptApi.getDepartmentPage(company);
  ///   // Throw ApiError
  ///   result2.throwIfError();
  ///   this.departmentPage = result2.data;
  ///   ...
  /// }
  /// ```
  ///
  Future<void> prepareFormMasterData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called after [prepareFormMasterData].
  ///
  Map<String, dynamic> prepareFormData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  // ***************************************************************************
  // ***************************************************************************

  // Private method. Only for use in this class.
  bool __checkValidBeforeSave() {
    return !block.__isSaving && (_formKey.currentState?.validate() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> saveForm() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: {},
      navigate: null,
    );
    //
    if (!__checkValidBeforeSave()) {
      return false;
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.block.name)!;
    _XFormModel xFormModel = xBlock.xFormModel!;
    _TaskUnit taskUnit = _SaveFormSaveTaskUnit(
      xFormModel: xFormModel,
    );
    //
    _taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFormModel(_XFormModel thisXFormModel) {
    if (!identical(thisXFormModel.formModel, this)) {
      String message =
          "Error Assets form model: ${thisXFormModel.formModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
