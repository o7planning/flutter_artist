part of '../flutter_artist.dart';

class FilterModelData<
    FILTER_INPUT extends FilterInput, //
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner FilterModel.
  ///
  final FilterModel<FILTER_INPUT, FILTER_CRITERIA> filterModel;

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

  FilterModelData({required this.filterModel});

  // ***************************************************************************
  // ***************************************************************************

  dynamic getProperty(String propName) {
    return _currentFormData[propName];
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState filterDataState}) {
    _filterDataState = filterDataState;
    //
    _justInitialized = false;
    //
    __initial0FormData.clear();
    _initialFormData.clear();
    _currentFormData.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initialFilterData(Map<String, dynamic> formData) {
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


  void _updateFilterData(Map<String, dynamic> updateData) {
    print("\n\n@ ~~~~~~~~~~~~~~~> 2.0 _updateFilterData/updateData: ${updateData}");
    print("@ ~~~~~~~~~~~~~~~> 2.1 _updateFilterData: ${_currentFormData}");


   List<String> props = [...updateData.keys];
   //
    for (String property in props) {

      print("@ ~~~~~~~~~~~~~~~> 2.1.1@@@ property: ${property}");
      final dynamic oldValue = _currentFormData[property];
      final dynamic newValue = updateData[property];
      //
      _currentFormData[property] = newValue;
      //
      final FindXList? findXList = this.filterModel._xListMap[property];
      if (findXList == null) {
        continue;
      }
      final XList? xList = findXList();
      if (xList == null) {
        continue;
      }
      bool isSame = xList.isSame(item1: oldValue, item2: newValue);
      if (!isSame) {
        print("@ ~~~~~~~~~~~~~~~> 2.2 _updateFilterData: ${_currentFormData}");
        this.filterModel._firePropertyChange(property: property);
      }
    }
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
