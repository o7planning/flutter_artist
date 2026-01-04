part of '../core.dart';

abstract class MultiOptFilterCriterionModel<V> extends FilterCriterionModel<V> {
  late final MultiOptFilterCriterionModel? parent;

  int _loadCount = 0;

  int get loadCount => _loadCount;

  ///
  /// In most cases this value is [SelectionType.single].
  /// For example a Dropdown that only allows selection of one element.
  ///
  /// IMPORTANT:
  ///
  /// Make sure you set the appropriate value for this property, otherwise an error will occur.
  /// For example: An error occurs when the library tries to set multiple selection values for the Dropdown.
  ///
  final SelectionType selectionType;
  final List<MultiOptFilterCriterionModel> _children = [];

  List<MultiOptFilterCriterionModel> get children =>
      List.unmodifiable(_children);

  MultiOptFilterCriterionModel._({
    required super.criterionNamePlus,
    required this.selectionType,
    super.description,
  });

  void _updateTempValueCascade({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[criterionNamePlus];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_tempCurrentXData != null) {
        if (selectionType == SelectionType.single) {
          isSame = _tempCurrentXData!.isSame(
            item1: oldValue,
            item2: newValue,
          );
        } else {
          isSame = _tempCurrentXData!.isSameItemOrItemList(
            itemOrItemList1: oldValue,
            itemOrItemList2: newValue,
          );
        }
      } else {
        isSame = false;
      }
      //
      if (_tempCurrentXData == null || newValue == null || !isSame) {
        for (MultiOptFilterCriterionModel childItem in children) {
          childItem._tempCurrentXData = null;
          updateValues[childItem.criterionNamePlus] = null;
          childItem._markTempDirty = true;
        }
      }
    }
    //
    for (MultiOptFilterCriterionModel childItem in children) {
      childItem._updateTempValueCascade(
        updateValues: updateValues,
      );
    }
  }
}
