part of '../flutter_artist.dart';

class BlockFormData<
    ID extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria, //
    EXTRA_FORM_INPUT extends ExtraFormInput> {
  ///
  /// Owner BlockForm.
  ///
  final BlockForm<
      ID, //
      ITEM_DETAIL,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> blockForm;

  bool _justInitialized = false;

  final Map<String, dynamic> __initial0FormData = {};

  Map<String, dynamic> get initial0FormData => {...__initial0FormData};

  //

  final Map<String, dynamic> _initialFormData = {};

  Map<String, dynamic> get initialFormData => {..._initialFormData};

  //

  final Map<String, dynamic> _currentFormData = {};

  Map<String, dynamic> get currentFormData => {..._currentFormData};

  //
  DataState _dataState = DataState.pending;

  FormMode _formMode = FormMode.none;

  FormMode get formMode => _formMode;

  bool get isNew => _formMode == FormMode.creation;

  // ***************************************************************************
  // ***************************************************************************

  BlockFormData({required this.blockForm});

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState formDataState}) {
    _dataState = formDataState;
    _formMode = FormMode.none;
    //
    _updateFormData({});
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  void _setCurrentItem({
    required ITEM_DETAIL? refreshedItemDetail,
    required FormMode formMode,
    required DataState dataState,
  }) {
    _formMode = formMode;
    _dataState = dataState;
  }
}
