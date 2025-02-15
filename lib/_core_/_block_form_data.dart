part of '../flutter_artist.dart';

class BlockFormData<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria, //
    EXTRA_FORM_INPUT extends ExtraInput> {
  ///
  /// Owner BlockForm.
  ///
  final BlockForm<ID, ITEM_DETAIL, FILTER_CRITERIA, EXTRA_FORM_INPUT> blockForm;

  bool _justInitialized = false;

  final Map<String, dynamic> __initial0FormData = {};

  final Map<String, dynamic> __initial0FormDataBk = {};

  Map<String, dynamic> get initial0FormData => {...__initial0FormData};

  //

  final Map<String, dynamic> _initialFormData = {};

  final Map<String, dynamic> __initialFormDataBk = {};

  Map<String, dynamic> get initialFormData => {..._initialFormData};

  //

  final Map<String, dynamic> _currentFormData = {};

  final Map<String, dynamic> __currentFormDataBk = {};

  Map<String, dynamic> get currentFormData => {..._currentFormData};

  //

  // TODO: Xoa di, khong su dung.
  DataState _dataState = DataState.pending;

  DataState __dataStateBk = DataState.pending;

  FormMode __formModeBk = FormMode.none;

  FormMode _formMode = FormMode.none;

  FormMode get formMode => _formMode;

  bool get isNew => _formMode == FormMode.creation;

  BlockFormData({required this.blockForm});

  bool _isDirty() {
    Set<String> keySet = {}
      ..addAll(_initialFormData.keys)
      ..addAll(_currentFormData.keys);
    //
    for (String key in keySet) {
      dynamic currentValue = _currentFormData[key];
      dynamic initialValue = _initialFormData[key];
      bool eq = _compareDynamicAndDynamic(currentValue, initialValue);
      if (!eq) {
        return true;
      }
    }
    return false;
  }

  void _updateFormData(Map<String, dynamic> formData) {
    _justInitialized = true;
    //
    __initial0FormData
      ..clear()
      ..addAll(formData);
    _initialFormData
      ..clear()
      ..addAll(formData);
    _currentFormData
      ..clear()
      ..addAll(formData);
  }

  void _setCurrentItem({
    required ITEM_DETAIL? refreshedItemDetail,
    required FormMode formMode,
    required DataState dataState,
  }) {
    _formMode = formMode;
    _dataState = dataState;
  }

  void _backup() {
    __formModeBk = _formMode;
    __dataStateBk = _dataState;

    __initial0FormDataBk
      ..clear()
      ..addAll(__initial0FormData);

    __initialFormDataBk
      ..clear()
      ..addAll(_initialFormData);

    __currentFormDataBk
      ..clear()
      ..addAll(_currentFormData);
  }

  void _restore() {
    _dataState = __dataStateBk;
    _formMode = __formModeBk;

    __initial0FormData
      ..clear()
      ..addAll(__initial0FormDataBk);

    _initialFormData
      ..clear()
      ..addAll(__initialFormDataBk);

    _currentFormData
      ..clear()
      ..addAll(__currentFormDataBk);
    //
    _applyNewState();
  }

  void _applyNewState() {
    __formModeBk = FormMode.none;
    __dataStateBk = DataState.ready;
    //
    __initial0FormDataBk
      ..clear()
      ..addAll(__initial0FormData);

    __initialFormDataBk
      ..clear()
      ..addAll(_initialFormData);

    __currentFormDataBk
      ..clear()
      ..addAll(_currentFormData);
  }
}
