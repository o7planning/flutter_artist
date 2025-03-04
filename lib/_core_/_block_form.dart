part of '../flutter_artist.dart';

abstract class BlockForm<
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

  late final BlockFormData data = BlockFormData(blockForm: this);

  FormMode get formMode => data.formMode;

  Shelf get shelf => block.shelf;

  late final Block<ID, Object, ITEM_DETAIL, FilterInput, FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  DataState get dataState => data._dataState;

  QueryMode get queryMode => _queryMode;

  QueryMode get temporaryQueryMode => _tempQueryMode;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final AutovalidateMode _defaultAutovalidateMode =
      AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  final Map<_RefreshableWidgetState, bool> _formWidgetStates = {};

  BlockForm();

  //
  void _addFormWidgetState({
    required _RefreshableWidgetState widgetState,
    required final bool isShowing,
  }) {
    bool isShowingOLD = _formWidgetStates[widgetState] ?? false;
    _formWidgetStates[widgetState] = isShowing;
    if (!isShowingOLD && isShowing) {
      block.shelf._startNewLazyQueryTransactionIfNeed();
    }
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  void _removeFormWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _formWidgetStates.remove(widgetState);
  }

  void updateAllUIComponents() {
    __updateFormWidgets();
  }

  ///
  /// Call this method to refresh Widgets..
  ///
  void __updateFormWidgets() {
    List<_RefreshableWidgetState> list = _getMountedFormWidgetStates();
    for (_RefreshableWidgetState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState();
      }
    }
  }

  List<_RefreshableWidgetState> _getMountedFormWidgetStates() {
    List<_RefreshableWidgetState> ret = [];
    for (_RefreshableWidgetState widgetState in [..._formWidgetStates.keys]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  bool hasMountedUIComponent() {
    return _formWidgetStates.isNotEmpty;
  }

  bool hasActiveUIComponent() {
    for (State formWidgetState in _formWidgetStates.keys) {
      bool visible = _formWidgetStates[formWidgetState] ?? false;
      if (visible && formWidgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool isDirty() {
    return data._isDirty();
  }

  bool isEnabled() {
    return block._isEnableFormToModify();
  }

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

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFormValue() {
    return data._currentFormData;
  }

  // Change Event from GUI.
  void _onChangeFromFormWidget() {
    if (_formKey.currentState?.instantValue != null) {
      data._currentFormData.addAll(_formKey.currentState!.instantValue);
      if (data._justInitialized) {
        data._initialFormData.addAll(_formKey.currentState!.instantValue);
      }
    }
  }

  void _afterBuildFormWidget() {
    data._justInitialized = false;
  }

  dynamic getFormInstantValue(String propertyName) {
    return data._currentFormData[propertyName];
  }

  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    data._currentFormData[propertyName] = value;
    this.updateAllUIComponents();
  }

  Future<ApiResultOLD<ITEM_DETAIL>> callApiCreateItem({
    required Map<String, dynamic> formMapData,
  });

  Future<ApiResultOLD<ITEM_DETAIL>> callApiUpdateItem({
    required Map<String, dynamic> formMapData,
  });

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
  ///   ApiResultOLD<CompanyPage> result1 = await companyApi.getCompanyPage();
  ///   // Throw ApiError
  ///   result1.throwIfError();
  ///   this.companyPage = result1.data;
  ///   CompanyInfo? company = this.companyPage.getSelectedCompany()
  ///
  ///   ApiResultOLD<DepartmentPage> result2 = await deptApi.getDepartmentPage(company);
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

  ///
  /// This method is called after [prepareFormMasterData].
  ///
  Map<String, dynamic> prepareFormData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  // Private method. Only for use in this class.
  bool __checkValidBeforeSave() {
    return !block.__isSaving && (_formKey.currentState?.validate() ?? false);
  }

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
    bool success = await _saveFormWithOverlayAndRestorable();
    return success;
  }

  Future<bool> _saveFormWithOverlayAndRestorable() async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _saveFormWithRestorable();
      },
    );
  }

  Future<bool> _saveFormWithRestorable() async {
    if (!__checkValidBeforeSave()) {
      return false;
    }
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: block._childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(block.name)!;
    try {
      shelf._backupAll();
      bool success = await __saveForm(
        thisXBlock: thisXBlock,
      );

      if (!success) {
        shelf._restoreAll();
      } else {
        shelf._applyNewStateAll();
      }
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "saveForm",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      block._restoreAllFromRoot();
      return false;
    }
  }

  // Private method. Only for use in this class.
  Future<bool> __saveForm({
    required _XBlock thisXBlock,
  }) async {
    Map<String, dynamic> formMapData = data.currentFormData;
    //
    String calledMethodName =
        data.isNew ? 'callApiCreateItem' : 'callApiUpdateItem';
    //
    ApiResultOLD<ITEM_DETAIL> result;
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
    try {
      return await block._processSaveActionRestResult(
        thisXBlock: thisXBlock,
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

  Future<bool> _prepareFormNull() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "_prepareFormNull",
      parameters: {},
    );
    //
    try {
      final Map<String, dynamic> newFormData = {};
      data._dataState = DataState.ready;
      data._updateFormData(newFormData);
      //
      _formKey.currentState?.patchValue(newFormData);
      //
      updateAllUIComponents(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
      //
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _prepareForm({
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required final bool isNew,
    required bool forceForm,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "_prepareForm",
      parameters: {
        "extraFormInput": extraFormInput,
        "refreshedItem": refreshedItem,
        "isNew": isNew,
        "forceForm": forceForm,
      },
    );
    //
    if (isNew && refreshedItem != null) {
      showErrorSnackBar(
        message: "Library Error",
        errorDetails: ["refreshedItem is not null in a new form"],
      );
      return false;
    } else if (!isNew && refreshedItem == null) {
      showErrorSnackBar(
        message: "Library Error",
        errorDetails: ["refreshedItem is null in a edit form"],
      );
      return false;
    }
    //
    bool needToLoad = forceForm || hasActiveUIComponent();
    //
    // Init Extra data for Edit Form:
    //
    if (needToLoad) {
      __loadCount++;
      FILTER_CRITERIA? filterCriteria = block.data.filterCriteria;
      //
      bool success = await __prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItem,
        isNew: isNew,
      );
      if (!success) {
        data._dataState = DataState.pending;
        return false;
      } else {
        data._dataState = DataState.ready;
      }
    } else {
      data._dataState = DataState.pending;
    }
    //
    bool success = __copyItemDataToFormKeyState(
      extraFormInput: extraFormInput,
      refreshedItem: refreshedItem,
      isNew: isNew,
    );
    if (!success) {
      return false;
    }
    return true;
  }

  // Private method in this class.
  Future<bool> __prepareFormMasterData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  }) async {
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: this,
        methodName: "prepareFormMasterData",
        parameters: {
          "filterCriteria": filterCriteria,
          "extraFormInput": extraFormInput,
          "refreshedItem": refreshedItem,
          "isNew": isNew,
        },
      );
      //
      // May throw ApiError.
      //
      await prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraFormInput: extraFormInput,
        refreshedItem: refreshedItem,
        isNew: isNew,
      );
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormMasterData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  // Private method. Only for use in this class.
  bool __copyItemDataToFormKeyState({
    required EXTRA_FORM_INPUT? extraFormInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  }) {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__copyItemDataToFormKeyState",
      parameters: {
        "refreshedItem": refreshedItem,
        "isNew": isNew,
      },
    );
    //
    Map<String, dynamic> newFormData;
    if (data._dataState == DataState.ready) {
      try {
        FILTER_CRITERIA? filterCriteria = block.data.filterCriteria;
        //
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          ownerClassInstance: this,
          methodName: "prepareFormData",
          parameters: {
            "filterCriteria": filterCriteria,
            "extraFormInput": extraFormInput,
            "refreshedItem": refreshedItem,
            "isNew": isNew,
          },
          navigate: null,
        );
        //
        newFormData = prepareFormData(
          filterCriteria: filterCriteria,
          extraFormInput: extraFormInput,
          refreshedItem: refreshedItem,
          isNew: isNew,
        );
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "prepareFormData",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
    } else {
      newFormData = {};
    }
    try {
      data._updateFormData(newFormData);
      updateAllUIComponents(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
      //
      _formKey.currentState?.patchValue(newFormData);
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareFormData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }
}
