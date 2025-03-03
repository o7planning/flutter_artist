part of '../flutter_artist.dart';

class DataFilterData<
    FILTER_INPUT extends FilterInput, //
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner DataFilter.
  ///
  final DataFilter<FILTER_INPUT, FILTER_CRITERIA> dataFilter;

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
  DataState _filterDataState = DataState.pending;

  // ***************************************************************************
  // ***************************************************************************

  DataFilterData({required this.dataFilter});

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState filterDataState}) {
    _filterDataState = filterDataState;
    //
    _updateFilterData({});
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFilterData(Map<String, dynamic> formData) {
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
}
