part of '../flutter_artist.dart';

abstract class BlockForm<I extends Object, D extends Object,
    SF extends SuggestedFormData> {
  QueryMode _queryMode = QueryMode.lazy;

  late QueryMode _tempQueryMode = _queryMode;

  // TODO: Chuyen sang Block.
  bool __isSaving = false;

  bool get isSaving => __isSaving;

  late final BlockFormData data = BlockFormData(blockForm: this);

  late final Block<I, D, FilterSnapshot, SF> block;

  DataState get dataState => data._dataState;

  QueryMode get queryMode => _queryMode;

  QueryMode get temporaryQueryMode => _tempQueryMode;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final AutovalidateMode _defaultAutovalidateMode =
      AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  D? item;

  final Map<_WidgetState, bool> _formWidgetStateListeners = {};

  BlockForm();

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool activeOnly,
    required bool withForm,
    required bool withControlBar,
  }) {
    Map<_WidgetState, bool> ret = {};
    if (withForm) {
      _removeUnmountedWidgetStates(_formWidgetStateListeners);
      Map<_WidgetState, bool> m = {..._formWidgetStateListeners};
      for (_WidgetState key in m.keys) {
        if (key.mounted) {
          if (!activeOnly || m[key]!) {
            ret[key] = m[key]!;
          }
        }
      }
    }
    //
    if (withControlBar) {
      _removeUnmountedWidgetStates(block._controlBarWidgetStateListeners);
      Map<_WidgetState, bool> m = {...block._controlBarWidgetStateListeners};
      for (_WidgetState key in m.keys) {
        if (key.mounted) {
          if (!activeOnly || m[key]!) {
            ret[key] = m[key]!;
          }
        }
      }
    }
    return ret;
  }

  //
  void _addWidgetStateListener({
    required _WidgetState formWidgetState,
    required final bool isShowing,
  }) {
    bool isShowingOLD = _formWidgetStateListeners[formWidgetState] ?? false;
    _formWidgetStateListeners[formWidgetState] = isShowing;
    if (!isShowingOLD && isShowing) {
      block.shelf._startNewLazyQueryTransactionIfNeed();
    }
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  ///
  /// Call this method to refresh Widgets..
  ///
  void updateFormWidgets() {
    List<_WidgetState> list = _getMountedFormWidgetStates();
    for (_WidgetState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState();
      }
    }
  }

  List<_WidgetState> _getMountedFormWidgetStates() {
    _removeUnmountedWidgetStates(_formWidgetStateListeners);
    List<_WidgetState> ret = [];
    for (_WidgetState widgetState in [..._formWidgetStateListeners.keys]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  bool hasActiveFormWidget() {
    _removeUnmountedWidgetStates(_formWidgetStateListeners);

    for (State formWidgetState in _formWidgetStateListeners.keys) {
      bool isShowing = _formWidgetStateListeners[formWidgetState] ?? false;
      if (isShowing && formWidgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool isDirty() {
    return data._isDirty();
  }

  bool isEnabled() {
    return block.canEditOnForm();
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
    updateFormWidgets();
    block.updateControlBarWidgets();
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
      if (data._justInited) {
        data._initialFormData.addAll(_formKey.currentState!.instantValue);
      }
    }
  }

  void _afterBuildFormWidget() {
    data._justInited = false;
  }

  dynamic getFormInstantValue(String propertyName) {
    return data._currentFormData[propertyName];
  }

  void setFormInstantValue(String propertyName, dynamic value) {
    _formKey.currentState?.patchValue({propertyName: value});
    data._currentFormData[propertyName] = value;
    this.updateFormWidgets();
  }

  // Developer do not call this method!
  // Call saveForm() instead of
  Future<ApiResult<D>> callApiCreate({
    required Map<String, dynamic> formMapData,
  });

  // Developer do not call this method!
  // Call saveForm() instead of
  Future<ApiResult<D>> callApiUpdate({
    required Map<String, dynamic> formMapData,
  });

  ///
  /// Call this method to initialize the necessary data for the Form.
  /// For example, the list of items of the [Dropdown].
  ///
  /// This method is called before [prepareFormData] method.
  ///
  Future<ApiResult<void>?>? prepareFormMasterData({
    required DataFilter? dataFilter, // TODO: FilterSnapShot??
    required SF? suggestedFormData,
    required D? refreshedItem,
    required bool isNew,
  });

  ///
  /// This method is called after [prepareFormMasterData].
  ///
  Map<String, dynamic> prepareFormData({
    required DataFilter? dataFilter,
    required SF? suggestedFormData,
    required D? refreshedItem,
    required bool isNew,
  });

  // TODO: Co ca trong Block.
  void showErrorSnackbar({
    required String message,
    required List<String>? errorDetails,
  }) {
    FlutterArtist.adapter.showErrorSnackbar(
      message: message,
      errorDetails: errorDetails,
    );
  }

  void _handleError({
    required String methodName,
    required dynamic error,
    required StackTrace stackTrace,
    required bool showSnackBar,
  }) {
    FlutterArtist.errorLogger.addError(
      shelfName: FlutterArtist.storage._getShelfName(block.shelf.runtimeType),
      message: error.toString(),
      errorDetails: null,
      stackTrace: stackTrace,
    );
    String msg = "Call ${getClassName(this)}.$methodName() error: $error";
    print(msg);
    print(stackTrace);
    if (showSnackBar) {
      showErrorSnackbar(
        message: msg,
        errorDetails: null,
      );
    }
  }

  // Private method. Only for use in this class.
  bool __checkValidBeforeSave() {
    return !__isSaving && (_formKey.currentState?.validate() ?? false);
  }

  Future<bool> saveForm() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "saveForm",
      parameters: {},
      route: null,
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
    try {
      block._backupAll();
      bool success = await __saveForm();

      if (!success) {
        block._restoreAll();
        return false;
      }
      block._applyNewStateAll();
      return true;
    } catch (e, stacktrace) {
      _handleError(
        methodName: "saveForm",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      block._restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class.
  Future<bool> __saveForm() async {
    Map<String, dynamic> formMapData = data.currentFormData;
    //
    String calledMethodName = data.isNew ? 'callApiCreate' : 'callApiUpdate';
    //
    ApiResult<D> result;
    try {
      __isSaving = true;
      this.block.updateControlBarWidgets();
      //
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        ownerClassInstance: this,
        methodName: calledMethodName,
        parameters: {
          "formMapData": formMapData,
        },
        route: null,
      );
      //
      result = data.isNew
          ? await callApiCreate(formMapData: formMapData)
          : await callApiUpdate(formMapData: formMapData);
      //
      __isSaving = false;
    } catch (e, stacktrace) {
      _handleError(
        methodName: calledMethodName,
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      __isSaving = false;
      return false;
    }
    try {
      return await block._processSaveActionRestResult(
        suggestedSelection: null,
        calledMethodName: calledMethodName,
        result: result,
      );
    } catch (e, stacktrace) {
      _handleError(
        methodName: '_processSaveActionRestResult',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _prepareForm({
    required SF? suggestedFormData,
    required D? refreshedItem,
    required final bool isNew,
    required bool forceForm,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "_prepareForm",
      parameters: {
        "suggestedFormData": suggestedFormData,
        "refreshedItem": refreshedItem,
        "isNew": isNew,
        "forceForm": forceForm,
      },
    );
    //

    bool needToLoad = forceForm || hasActiveFormWidget();
    //
    // Init Extra data for Edit Form:
    //
    if (needToLoad) {
      bool success = await __prepareFormMasterData(
        dataFilter: block.dataFilter,
        suggestedFormData: suggestedFormData,
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
      suggestedFormData: suggestedFormData,
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
    required DataFilter? dataFilter, // TODO: FilterSnapShot??
    required SF? suggestedFormData,
    required D? refreshedItem,
    required bool isNew,
  }) async {
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        route: null,
        ownerClassInstance: this,
        methodName: "prepareFormMasterData",
        parameters: {
          "dataFilter": dataFilter,
          "suggestedFormData": suggestedFormData,
          "refreshedItem": refreshedItem,
          "isNew": isNew,
        },
      );
      //
      Future<ApiResult<void>?>? future = prepareFormMasterData(
        dataFilter: dataFilter,
        suggestedFormData: suggestedFormData,
        refreshedItem: refreshedItem,
        isNew: isNew,
      );
      if (future != null) {
        ApiResult<void>? result = await future;

        if (result != null && result.isError()) {
          block._handleRestError(
            methodName: "prepareFormMasterData",
            message: result.errorMessage!,
            errorDetails: result.errorDetails,
            showSnackBar: true,
          );
          return false;
        }
      }
      return true;
    } catch (e, stacktrace) {
      _handleError(
        methodName: "prepareFormMasterData",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  // Private method. Only for use in this class.
  bool __copyItemDataToFormKeyState({
    required SF? suggestedFormData,
    required D? refreshedItem,
    required bool isNew,
  }) {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
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
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          ownerClassInstance: this,
          methodName: "prepareFormData",
          parameters: {
            "dataFilter": block.dataFilter,
            "suggestedFormData": suggestedFormData,
            "refreshedItem": refreshedItem,
            "isNew": isNew,
          },
          route: null,
        );
        //
        newFormData = prepareFormData(
          dataFilter: block.dataFilter,
          suggestedFormData: suggestedFormData,
          refreshedItem: refreshedItem,
          isNew: isNew,
        );
      } catch (e, stacktrace) {
        _handleError(
          methodName: "prepareFormData",
          error: e,
          stackTrace: stacktrace,
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
      updateFormWidgets(); // TODO: Xu ly loi?
      block.updateControlBarWidgets();
      //
      _formKey.currentState?.patchValue(newFormData);
      return true;
    } catch (e, stacktrace) {
      _handleError(
        methodName: "prepareFormData",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }
}
