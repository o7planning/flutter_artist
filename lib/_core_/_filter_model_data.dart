part of '../flutter_artist.dart';

class FilterModelData<
    FILTER_INPUT extends FilterInput, //
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner FilterModel.
  ///
  final FilterModel<FILTER_INPUT, FILTER_CRITERIA> filterModel;

  final Map<String, dynamic> __initial0FormData = {};

  Map<String, dynamic> get initial0FormData => {...__initial0FormData};

  //

  final Map<String, dynamic> _initialFormData = {};

  Map<String, dynamic> get initialFormData => {..._initialFormData};

  //

  final Map<String, dynamic> _currentFormData = {};

  Map<String, dynamic> get currentFormData => {..._currentFormData};

  //
  DataState _filterDataState = DataState.pending;

  // ***************************************************************************
  // ***************************************************************************

  FilterModelData({required this.filterModel});

  // ***************************************************************************
  // ***************************************************************************

  X? getProperty<X>(String propName) {
    return _currentFormData[propName] as X?;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState filterDataState}) {
    _filterDataState = filterDataState;
    //
    __initial0FormData.clear();
    _initialFormData.clear();
    _currentFormData.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initialFilterData(Map<String, dynamic> formData) {
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
}
