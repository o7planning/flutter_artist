part of '../flutter_artist.dart';

class FormModelData<
    ID extends Object, //
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> {
  ///
  /// Owner FormModel.
  ///
  final FormModel<
      ID, //
      ITEM_DETAIL,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> formModel;

  bool _justInitialized = false;

 // final Map<String, dynamic> __initial0FormData = {};

 // Map<String, dynamic> get initial0FormData => {...__initial0FormData};

  //

 // final Map<String, dynamic> __initialFormData = {};

 // Map<String, dynamic> get initialFormData => {...__initialFormData};

  //

 // final Map<String, dynamic> _currentFormData = {};

 // Map<String, dynamic> get currentFormData => {..._currentFormData};

  //
  // DataState _formDataState = DataState.none;

  // FormMode _formMode = FormMode.none;

 // FormMode get formMode => _formMode;

  // bool get isNew => _formMode == FormMode.creation;

  // ***************************************************************************
  // ***************************************************************************

  FormModelData({required this.formModel});

  // ***************************************************************************
  // ***************************************************************************

  // void _clearWithDataState({required DataState formDataState}) {
  //   _formDataState = formDataState;
  //   _formMode = FormMode.none;
  //   //
  //   _updateFormData({});
  // }

  // ***************************************************************************
  // ***************************************************************************
  ///
  /// After save successful, update [__initialFormData].
  ///
  // void _updateInitialFormDataAfterSaveSuccess() {
  //   __initialFormData
  //     ..clear()
  //     ..addAll(_currentFormData);
  //   // TODO: Update OptProp Data??
  // }

  ///
  /// For the first load of an Item, update [__initialFormData].
  /// Initial [OptProp] data will be update later...
  ///
  // void _setInitialFormDataForItemFirstLoad() {
  //   __initialFormData
  //     ..clear()
  //     ..addAll(_currentFormData);
  //   // TODO: OptProp data?
  // }

  ///
  /// Reset FormData:
  ///
  // void _resetFormData() {
  //   _currentFormData
  //     ..clear()
  //     ..addAll(__initialFormData);
  //   // TODO: Reset [OptProp] data?
  // }

  // void _clearInititalFormData() {
  //   __initial0FormData.clear();
  //   __initialFormData.clear();
  // }

  // void _updateInitialFormData(Map<String, dynamic> formData) {
  //   __initial0FormData
  //     ..clear()
  //     ..addAll(formData);
  //   __initialFormData
  //     ..clear()
  //     ..addAll(formData);
  // }

  // ***************************************************************************
  // ***************************************************************************

  // void _updateFormData(Map<String, dynamic> formData) {
  //   _justInitialized = true;
  //   //
  //   __initial0FormData
  //     ..clear()
  //     ..addAll(formData);
  //   __initialFormData
  //     ..clear()
  //     ..addAll(formData);
  //   _currentFormData
  //     ..clear()
  //     ..addAll(formData);
  // }

  // ***************************************************************************
  // ***************************************************************************

  // bool _isDirty() {
  //   Set<String> keySet = {}
  //     ..addAll(__initialFormData.keys)
  //     ..addAll(_currentFormData.keys);
  //   //
  //   for (String key in keySet) {
  //     dynamic currentValue = _currentFormData[key];
  //     dynamic initialValue = __initialFormData[key];
  //     bool eq = _compareDynamicAndDynamic(currentValue, initialValue);
  //     if (!eq) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // ***************************************************************************
  // ***************************************************************************

  // void _setCurrentItem({
  //   required ITEM_DETAIL? refreshedItemDetail,
  //   required FormMode formMode,
  //   required DataState formDataState,
  // }) {
  //   _formMode = formMode;
  //   _formDataState = formDataState;
  // }
}
