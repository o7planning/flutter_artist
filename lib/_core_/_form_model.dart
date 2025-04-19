part of '../flutter_artist.dart';

abstract class FormModel<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> extends _XBase {
  int __loadCount = 0;

  int get loadCount => __loadCount;

  int __formTransactionCount = 0;

  int get formTransactionCount => __formTransactionCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  String get id {
    return "block-form > ${shelf.name} > ${block.name}";
  }

  bool _changeEventLocked = false;

  FormMode get formMode => _formPropsStructure.formMode;

  DataState get formDataState => _formPropsStructure._formDataState;

  Shelf get shelf => block.shelf;

  late final Block<
      ID, //
      Object,
      ITEM_DETAIL,
      FilterInput,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  bool _defaultValueInitiated = false;

  final _defaultAutovalidateMode = AutovalidateMode.onUserInteraction;

  late AutovalidateMode autovalidateMode = _defaultAutovalidateMode;

  final Map<_RefreshableWidgetState, _XState> _formWidgetStates = {};

  // ***************************************************************************

  late final FormPropsStructure _formPropsStructure;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // ***************************************************************************
  // ***************************************************************************

  FormModel() {
    __registerPropsStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// FormPropsStructure registerPropsStructure() {
  ///   return FormPropsStructure(
  ///     simpleProps: [],
  ///     multiOptProps: [
  ///       MultiOptProp(
  ///         propName: "company",
  ///         children: [
  ///           MultiOptProp(
  ///              propName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  FormPropsStructure registerPropsStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  Future<XData?> callApiLoadMultiOptPropData({
    required String multiOptPropName,
    required Object? parentMultiOptPropValue,
    required FILTER_CRITERIA filterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<Map<String, dynamic>?> specifyDefaultSimplePropValues({
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<Map<String, dynamic>> getSimplePropValuesFromItemDetail({
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? getMultiOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
    required Object? parentMultiOptPropValue,
  });

  // ***************************************************************************
  // ***************************************************************************

  Map<String, dynamic>? getSimplePropValuesFromExtraFormInput({
    required EXTRA_FORM_INPUT extraFormInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitFormViewChanged({
    required _XFormModel xFormModel,
  }) async {
    __assertThisXFormModel(xFormModel);
    //
    await _startNewFormTransaction(
      extraFormInput: null,
      formDataAction: _FormDataAction.updateFromFormView,
    );
    return true;
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
        if (this.formDataState == DataState.error ||
            this.formDataState == DataState.pending) {
          _clearWithDataState(formDataState: this.formDataState);
          return true;
        } else {
          return true;
        }
      } else {
        if (this.formDataState == DataState.error ||
            this.formDataState == DataState.pending) {
          forceForm = true;
        } else {
          return true;
        }
      }
    }
    //
    __loadCount++;
    //
    EXTRA_FORM_INPUT? extraFormInput =
        thisXFormModel.extraFormInput as EXTRA_FORM_INPUT?;
    //
    await _startNewFormTransaction(
      extraFormInput: extraFormInput,
      formDataAction: _FormDataAction.itemFirstLoad,
    );
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitQuickExtraFormInput({
    required _XFormModel thisXFormModel,
    required EXTRA_FORM_INPUT extraFormInput,
  }) async {
    __assertThisXFormModel(thisXFormModel);
    //
    await _startNewFormTransaction(
      extraFormInput: extraFormInput,
      formDataAction: _FormDataAction.autoEnterFormFields,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitSaveForm({required _XFormModel thisXFormModel}) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw _FatalAppException(message: "FilterCriteria is null");
    }
    if (!__checkValidBeforeSave()) {
      return false;
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
      Object? parentBlockItem = block.parent?.currentItem;
      //
      result = _formPropsStructure.isNew
          ? await callApiCreateItem(
              filterCriteria: blockCurrentFilterCriteria,
              parentBlockItem: parentBlockItem,
              formMapData: formMapData,
            )
          : await callApiUpdateItem(
              filterCriteria: blockCurrentFilterCriteria,
              parentBlockItem: parentBlockItem,
              formMapData: formMapData,
            );
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
        blockCurrentFilterCriteria: blockCurrentFilterCriteria,
        calledMethodName: calledMethodName,
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: calledMethodName,
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

  void __registerPropsStructure() {
    _formPropsStructure = registerPropsStructure();
    _formPropsStructure.formModel = this;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @ImportantMethodAnnotation()
  Future<bool> _startNewFormTransaction({
    required EXTRA_FORM_INPUT? extraFormInput,
    required _FormDataAction formDataAction,
  }) async {
    FILTER_CRITERIA? blockCurrentFilterCriteria = block.filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      throw AppException(message: "FilterCriteria is null");
    }
    __formTransactionCount++;
    print(
        "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> _startNewFormTransaction, formDataAction: $formDataAction");

    final ITEM_DETAIL? itemDetail = block.currentItemDetail;
    final FormMode currentFormMode = formDataState == DataState.none
        ? FormMode.none
        : itemDetail == null
            ? FormMode.creation
            : FormMode.edit;
    _formPropsStructure._setFormMode(currentFormMode);
    final bool isNoneMode = currentFormMode == FormMode.none;
    final bool isCreationMode = currentFormMode == FormMode.creation;
    //
    if (formDataAction == _FormDataAction.itemFirstLoad) {
      if (isNoneMode || isCreationMode) {
        _defaultValueInitiated = false;
      }
    }
    //
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    _formPropsStructure._initTemporaryForNewTransaction(
      formDataAction: formDataAction,
      // Data from FormView:
      formKeyInstantValues: formKeyInstantValues,
    );
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptProp multiOptProp in _formPropsStructure._rootOptProps) {
        //
        // Load OptProp Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: null,
          parentValueIsInitialValue: true,
          multiOptProp: multiOptProp,
          formKeyInstantValues: formKeyInstantValues,
          formDataAction: formDataAction,
        );
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLoadMultiOptPropData",
        error: "Error callApiLoadMultiOptPropData: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      __applyWithDataState(
        formDataState: DataState.error,
        formDataAction: formDataAction,
      );
      return false;
    }
    //
    // Get SimpleProp Value:
    //
    Map<String, dynamic> simplePropValue = {};
    if (formDataAction == _FormDataAction.itemFirstLoad) {
      print("@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> 1");
      if (itemDetail != null) {
        try {
          simplePropValue = await getSimplePropValuesFromItemDetail(
            filterCriteria: blockCurrentFilterCriteria,
            itemDetail: itemDetail,
          );
          for (String propName in simplePropValue.keys) {
            // In (First load + itemDetail != null)
            _formPropsStructure._setTempSimplePropValue(
              propName: propName,
              value: simplePropValue[propName],
              setForInitial: true,
            );
          }
        } catch (e, stackTrace) {
          _handleError(
            shelf: shelf,
            methodName: "getSimplePropValuesFromItemDetail",
            error: "Error getSimplePropValuesFromItemDetail: $e",
            stackTrace: stackTrace,
            showSnackBar: true,
          );
          //
          __applyWithDataState(
            formDataState: DataState.error,
            formDataAction: formDataAction,
          );
          return false;
        }
      }
      // itemDetail == null
      else {
        print(
            "@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> 4: $_defaultValueInitiated");
        Map<String, dynamic> simplePropValueDefault = {};
        Map<String, dynamic> simplePropValueExtra = {};
        if (!_defaultValueInitiated) {
          print(
              "@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> 5: $_defaultValueInitiated");
          try {
            simplePropValueDefault = await specifyDefaultSimplePropValues(
                  filterCriteria: blockCurrentFilterCriteria,
                ) ??
                {};
            print(
                "@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> 5.1: simplePropValueDefault: $simplePropValueDefault");
            for (String propName in simplePropValueDefault.keys) {
              // In (Item First Load + itemDetail == null + !_defaultValueInitiated)
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: simplePropValueDefault[propName],
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            _handleError(
              shelf: shelf,
              methodName: "specifyDefaultSimplePropValues",
              error: "Error specifyDefaultSimplePropValues: $e",
              stackTrace: stackTrace,
              showSnackBar: true,
            );
            //
            __applyWithDataState(
              formDataState: DataState.error,
              formDataAction: formDataAction,
            );
            return false;
          }
        }
        print(
            "@~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> 6: $_defaultValueInitiated");
        //
        if (extraFormInput != null) {
          try {
            simplePropValueExtra = getSimplePropValuesFromExtraFormInput(
                  extraFormInput: extraFormInput,
                ) ??
                {};
            //
            for (String propName in simplePropValueExtra.keys) {
              // In (ItemFirstLoad + itemDetail == null + extraFormInput != null)
              _formPropsStructure._setTempSimplePropValue(
                propName: propName,
                value: simplePropValueExtra[propName],
                setForInitial: true,
              );
            }
          } catch (e, stackTrace) {
            _handleError(
              shelf: shelf,
              methodName: "getSimplePropValuesFromItemDetail",
              error: "Error getSimplePropValuesFromItemDetail: $e",
              stackTrace: stackTrace,
              showSnackBar: true,
            );
            //
            __applyWithDataState(
              formDataState: DataState.error,
              formDataAction: formDataAction,
            );
            return false;
          }
        }
      }
    }
    //
    else if (formDataAction == _FormDataAction.autoEnterFormFields) {
      if (extraFormInput != null) {
        try {
          Map<String, dynamic> simplePropValueExtra =
              getSimplePropValuesFromExtraFormInput(
                    extraFormInput: extraFormInput,
                  ) ??
                  {};
          //
          for (String propName in simplePropValueExtra.keys) {
            // In (autoEnterFormFields + extraFormInput != null)
            _formPropsStructure._setTempSimplePropValue(
              propName: propName,
              value: simplePropValueExtra[propName],
              setForInitial: false,
            );
          }
        } catch (e, stackTrace) {
          _handleError(
            shelf: shelf,
            methodName: "getSimplePropValuesFromItemDetail",
            error: "Error getSimplePropValuesFromItemDetail: $e",
            stackTrace: stackTrace,
            showSnackBar: true,
          );
          //
          __applyWithDataState(
            formDataState: DataState.error,
            formDataAction: formDataAction,
          );
          return false;
        }
      }
    }
    //
    return __applyWithDataState(
      formDataState: DataState.ready,
      formDataAction: formDataAction,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __applyWithDataState({
    required DataState formDataState,
    required _FormDataAction formDataAction,
  }) {
    _formPropsStructure.__isTempMode = false;
    try {
      //
      // Update Real FromData from Temporary FormData:
      //
      _formPropsStructure._updateTempToReal();

      //
      // UPDATE OPT-DATA:
      //  - optProp._xOptionedData = optProp._tempXData;
      //
      // _formPropsStructure._applyAllTempDataToReal();
      //
      if (formDataAction == _FormDataAction.itemFirstLoad) {
        _formPropsStructure._setInitialFormDataForItemFirstLoad();
      }

      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _defaultValueInitiated = true;
      _formPropsStructure._setFormDataState(formDataState);
      if (formDataAction == _FormDataAction.itemFirstLoad &&
          formMode == FormMode.edit &&
          _formKey.currentState != null) {
        if (!_formKey.currentState!.isValid) {
          _formKey.currentState!.validate(focusOnInvalid: false);
        }
      }
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
      // IMPORTANT: Restore OLD State:
      // Note [_formKeyPatchValue] NOT WORK!.
      //
      _formKeyPatchValue(
        newCurrentValue: _formPropsStructure.currentFormData,
      );
      //
      _formPropsStructure._setFormDataState(DataState.error);
      return false;
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
    required FILTER_CRITERIA blockCurrentFilterCriteria,
    required EXTRA_FORM_INPUT? extraFormInput,
    required Object? parentMultiOptPropValue,
    required MultiOptProp multiOptProp,
    required bool parentValueIsInitialValue,
    required Map<String, dynamic> formKeyInstantValues,
    required _FormDataAction formDataAction,
  }) async {
    final String multiOptPropName = multiOptProp.propName;

    // Get current OptProp data:
    XData? tempMultiOptPropXData =
        _formPropsStructure._getTempMultiOptPropXData(multiOptPropName);

    final dynamic tempInitialMultiOptValue = _formPropsStructure
        ._getTempInitialPropValue(propName: multiOptPropName);
    final dynamic tempCurrentMultiOptValue = _formPropsStructure
        ._getTempCurrentPropValue(propName: multiOptPropName);

    //
    dynamic newSelectedValue = _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );
    if (formDataAction == _FormDataAction.updateFromFormView) {
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
      _formPropsStructure._updatePropsTempValues({multiOptPropName: null});
    }

    //
    // Load OptProp data from Rest API.
    // May throw ApiError.
    //
    tempMultiOptPropXData ??= await callApiLoadMultiOptPropData(
      filterCriteria: blockCurrentFilterCriteria,
      extraFormInput: extraFormInput,
      parentMultiOptPropValue: parentMultiOptPropValue,
      multiOptPropName: multiOptPropName,
    );
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    ValueWrap? initialValueWrap;
    final ITEM_DETAIL? currentItemDetail = block.currentItemDetail;
    //
    if (tempMultiOptPropXData != null) {
      // Item First Load:
      if (formDataAction == _FormDataAction.itemFirstLoad) {
        if (currentItemDetail == null) {
          if (extraFormInput != null) {
            initialValueWrap = __getMultiOptPropValueFromExtraFormInput(
              extraFormInput: extraFormInput,
              multiOptPropXData: tempMultiOptPropXData,
              multiOptPropName: multiOptPropName,
              parentMultiOptPropValue: parentMultiOptPropValue,
            );
          } else {
            if (!_defaultValueInitiated) {
              initialValueWrap = __specifyDefaultMultiOptPropValue(
                multiOptPropName: multiOptPropName,
                multiOptPropXData: tempMultiOptPropXData,
                parentMultiOptPropValue: parentMultiOptPropValue,
              );
            }
          }
        }
        // currentItemDetail != null
        else {
          initialValueWrap = __getMultiOptPropValueFromItemDetail(
            itemDetail: currentItemDetail,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
            parentMultiOptPropValue: parentMultiOptPropValue,
          );
        }
      }
      // Auto Enter Form Fields:
      else if (formDataAction == _FormDataAction.autoEnterFormFields) {
        if (extraFormInput != null) {
          initialValueWrap = __getMultiOptPropValueFromExtraFormInput(
            extraFormInput: extraFormInput,
            multiOptPropXData: tempMultiOptPropXData,
            multiOptPropName: multiOptPropName,
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
          currentSelectedItems =
              tempCurrentValue.isEmpty ? null : tempCurrentValue;
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
    // optPropData == null
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
    if (formDataAction == _FormDataAction.itemFirstLoad) {
      initialValue = initialValueWrap?.values;
    } else {
      initialValue = _formPropsStructure._getInitialPropValue(
        propName: multiOptPropName,
      );
    }
    //
    if (formDataAction == _FormDataAction.itemFirstLoad ||
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
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (multiOptProp.singleSelection) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _formPropsStructure
            ._updatePropsTempValues({multiOptPropName: candidateSelectedItem});
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptProp to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _formPropsStructure
            ._updatePropsTempValues({multiOptPropName: candidateSelectedItems});
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptProp to null if parent-Value is null or not selected.
      _formPropsStructure._updatePropsTempValues({multiOptPropName: null});
    }
    //
    Object? tempSelectedPropValue =
        _formPropsStructure._getTempCurrentPropValue(
      propName: multiOptPropName,
    );

    if (tempSelectedPropValue != null) {
      for (MultiOptProp child in multiOptProp.children) {
        await _loadMultiOptPropDataCascade(
          blockCurrentFilterCriteria: blockCurrentFilterCriteria,
          extraFormInput: extraFormInput,
          parentMultiOptPropValue: tempSelectedPropValue,
          parentValueIsInitialValue: multiOptValueIsInitialValue,
          multiOptProp: child,
          formKeyInstantValues: formKeyInstantValues,
          formDataAction: formDataAction,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getCurrentPropValue(String propName) {
    return _formPropsStructure._getCurrentPropValue(propName: propName);
  }

  XData? getMultiOptPropXData(String multiOptPropName) {
    return _formPropsStructure._getMultiOptPropXData(multiOptPropName);
  }

  dynamic getMultiOptPropData(String multiOptPropName) {
    XData? multiOptPropXData = getMultiOptPropXData(multiOptPropName);
    dynamic data = multiOptPropXData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? __specifyDefaultMultiOptPropValue({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
  }) {
    ValueWrap? valueWrap = specifyDefaultMultiOptPropValue(
      multiOptPropXData: multiOptPropXData,
      multiOptPropName: multiOptPropName,
      parentMultiOptPropValue: parentMultiOptPropValue,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppException(
        methodName: "specifyDefaultMultiOptPropValue",
        multiOptPropName: multiOptPropName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return ValueWrap.multi(
      multiOptPropXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppException({
    required String methodName,
    required String multiOptPropName,
  }) {
    MultiOptProp? multiOptProp =
        _formPropsStructure._getMultiOptProp(multiOptPropName);
    if (multiOptProp == null) {
      throw "The '$multiOptPropName' is not $MultiOptProp";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $ValueWrap for the multiOptPropName '$multiOptPropName'. ";
    if (multiOptProp.singleSelection) {
      message += "$ValueWrap.single(null) or $ValueWrap.single(value). ";
    } else {
      message += "$ValueWrap.multi([null]) or $ValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptProp. See the specification of this method for more information.";
    // throw AppException(message: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? __getMultiOptPropValueFromItemDetail({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required ITEM_DETAIL itemDetail,
    required Object? parentMultiOptPropValue,
  }) {
    ValueWrap? valueWrap = getMultiOptPropValueFromItemDetail(
      multiOptPropName: multiOptPropName,
      multiOptPropXData: multiOptPropXData,
      itemDetail: itemDetail,
      parentMultiOptPropValue: parentMultiOptPropValue,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppException(
        methodName: "getMultiOptPropValueFromItemDetail",
        multiOptPropName: multiOptPropName,
      );
    }
    return valueWrap;
  }

  // ***************************************************************************
  // ***************************************************************************

  ValueWrap? __getMultiOptPropValueFromExtraFormInput({
    required String multiOptPropName,
    required XData multiOptPropXData,
    required EXTRA_FORM_INPUT extraFormInput,
    required Object? parentMultiOptPropValue,
  }) {
    if (extraFormInput is EmptyExtraFormInput) {
      return null;
    }
    ValueWrap? valueWrap = getMultiOptPropValueFromExtraFormInput(
      extraFormInput: extraFormInput,
      multiOptPropXData: multiOptPropXData,
      multiOptPropName: multiOptPropName,
      parentMultiOptPropValue: parentMultiOptPropValue,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppException(
        methodName: "getMultiOptPropValueFromExtraFormInput",
        multiOptPropName: multiOptPropName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return ValueWrap.multi(
      multiOptPropXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: true,
        removeCurrentNotFoundItems: true,
      ),
    );
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

  void _clearWithDataState({required DataState formDataState}) {
    try {
      _formPropsStructure._clearFormDataWithState(
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

  void _setFormViewBuildingState({
    required _RefreshableWidgetState widgetState,
    required bool isBuilding,
  }) {
    _formWidgetStates.update(
      widgetState,
      (xState) => xState..isBuilding = isBuilding,
      ifAbsent: () => _XState()..isBuilding = isBuilding,
    );
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
    return _formPropsStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    Actionable actionable = block._isEnableFormToModify();
    print("Action >>>>>>>>>> ${actionable.message}");
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
      shelf.updateAllUIComponents();
    } finally {
      _changeEventLocked = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  Future<void> _onChangeFromFormView() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromFormView");
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(block.name)!;
    _XFormModel xFormModel = xBlock.xFormModel!;
    _FormViewChangeTaskUnit taskUnit =
        _FormViewChangeTaskUnit(xFormModel: xFormModel);
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    await FlutterArtist.executor._executeTaskUnitQueue(showOverlay: false);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _formWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFormView() {
    _formPropsStructure._justInitialized = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Change name!
  // Do not call this method in library.
  Map<String, dynamic> initFormValue() {
    return _formPropsStructure.currentFormData;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInitialValue(String propertyName) {
    return _formPropsStructure.initialFormData[propertyName];
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getFormInstantValue(String propertyName) {
    return _formPropsStructure.currentFormData[propertyName];
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
    this.updateAllUIComponents();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiCreateItem({
    required FILTER_CRITERIA filterCriteria,
    required Object? parentBlockItem,
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<ITEM_DETAIL>> callApiUpdateItem({
    required FILTER_CRITERIA filterCriteria,
    required Object? parentBlockItem,
    required Map<String, dynamic> formMapData,
  });

  // ***************************************************************************
  // ***************************************************************************

  // Private method. Only for use in this class.
  bool __checkValidBeforeSave() {
    return !block.__isSaving && (_formKey.currentState?.validate() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> enterFormFields({
    required EXTRA_FORM_INPUT extraFormInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "enterFormFields",
      parameters: {"extraFormInput": extraFormInput},
      navigate: null,
    );
    //
    if (formMode == FormMode.none) {
      throw _FatalAppException(message: "Form in 'none' mode");
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
    _TaskUnit taskUnit = _FormModelAutoEnterFormFieldsTaskUnit(
      xFormModel: xFormModel,
      extraFormInput: extraFormInput,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
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
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
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
