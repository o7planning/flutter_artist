part of '../flutter_artist.dart';

abstract class BlockForm<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_INPUT extends ExtraInput> extends _XBase {
  QueryMode _queryMode = QueryMode.lazy;

  late QueryMode _tempQueryMode = _queryMode;

  String get id {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  late final BlockFormData data = BlockFormData(blockForm: this);

  Shelf get shelf => block.shelf;

  late final Block<ID, ITEM, ITEM_DETAIL, FilterInput, FILTER_CRITERIA,
      EXTRA_INPUT> block;

  DataState get dataState => data._dataState;

  QueryMode get queryMode => _queryMode;

  QueryMode get temporaryQueryMode => _tempQueryMode;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final AutovalidateMode _defaultAutovalidateMode =
      AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  ITEM_DETAIL? item;

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
    return block.canEditCurrentItemOnForm();
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

  Future<ApiResult<ITEM_DETAIL>> callApiCreate({
    required Map<String, dynamic> formMapData,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiUpdate({
    required Map<String, dynamic> formMapData,
  });

  ///
  /// Call this method to initialize the necessary data for the Form.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [prepareFormData] method.
  ///
  Future<ApiResult<void>?>? prepareFormMasterData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_INPUT? extraInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  ///
  /// This method is called after [prepareFormMasterData].
  ///
  Map<String, dynamic> prepareFormData({
    required FILTER_CRITERIA? filterCriteria,
    required EXTRA_INPUT? extraInput,
    required ITEM_DETAIL? refreshedItem,
    required bool isNew,
  });

  // TODO: Co ca trong Block.
  @override
  void showErrorSnackBar({
    required String message,
    required List<String>? errorDetails,
  }) {
    FlutterArtist.adapter.showErrorSnackBar(
      message: message,
      errorDetails: errorDetails,
    );
  }

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
    String calledMethodName = data.isNew ? 'callApiCreate' : 'callApiUpdate';
    //
    ApiResult<ITEM_DETAIL> result;
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
          ? await callApiCreate(formMapData: formMapData)
          : await callApiUpdate(formMapData: formMapData);
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

  Future<bool> _prepareForm({
    required EXTRA_INPUT? extraInput,
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
        "extraInput": extraInput,
        "refreshedItem": refreshedItem,
        "isNew": isNew,
        "forceForm": forceForm,
      },
    );
    //
    bool needToLoad = forceForm || hasActiveUIComponent();
    //
    // Init Extra data for Edit Form:
    //
    if (needToLoad) {
      FILTER_CRITERIA? filterCriteria = block.data.filterCriteria;
      //
      bool success = await __prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraInput: extraInput,
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
      extraInput: extraInput,
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
    required EXTRA_INPUT? extraInput,
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
          "extraInput": extraInput,
          "refreshedItem": refreshedItem,
          "isNew": isNew,
        },
      );
      //
      Future<ApiResult<void>?>? future = prepareFormMasterData(
        filterCriteria: filterCriteria,
        extraInput: extraInput,
        refreshedItem: refreshedItem,
        isNew: isNew,
      );
      if (future != null) {
        ApiResult<void>? result = await future;

        if (result != null && result.isError()) {
          _handleRestError(
            shelf: shelf,
            methodName: "prepareFormMasterData",
            message: result.errorMessage!,
            errorDetails: result.errorDetails,
            showSnackBar: true,
          );
          return false;
        }
      }
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
    required EXTRA_INPUT? extraInput,
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
            "extraInput": extraInput,
            "refreshedItem": refreshedItem,
            "isNew": isNew,
          },
          navigate: null,
        );
        //
        newFormData = prepareFormData(
          filterCriteria: filterCriteria,
          extraInput: extraInput,
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
