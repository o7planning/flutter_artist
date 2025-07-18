part of '../../flutter_artist.dart';

class MultiOptProp<V> extends Prop<V> {
  late final MultiOptProp? parent;
  final MultiOptPropReload reloadCondition;

  bool _markToReload = false;
  int _loadCount = 0;

  int get loadCount => _loadCount;

  ///
  /// In most cases this value is [true].
  /// For example a Dropdown that only allows selection of one element.
  ///
  /// IMPORTANT:
  ///
  /// Make sure you set the appropriate value for this property, otherwise an error will occur.
  /// For example: An error occurs when the library tries to set multiple selection values for the Dropdown.
  ///
  final bool singleSelection;
  final List<MultiOptProp> _children;

  List<MultiOptProp> get children => [..._children];

  MultiOptProp({
    required super.propName,
    this.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
    List<MultiOptProp> children = const [],
  })
      : singleSelection = true,
        _children = children;

  MultiOptProp.multiSelection({
    required super.propName,
    this.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  })
      : singleSelection = false,
        _children = const [];

  void _updateTempValueCascade({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[propName];
      //
      _candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_tempCurrentXData != null) {
        if (singleSelection) {
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
        for (MultiOptProp childItem in _children) {
          childItem._tempCurrentXData = null;
          updateValues[childItem.propName] = null;
          childItem._markTempDirty = true;
        }
      }
    }
    //
    for (MultiOptProp childItem in _children) {
      childItem._updateTempValueCascade(
        updateValues: updateValues,
      );
    }
  }

  void _printTempInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " *
            indentFactor)} $propName >>> UpdateVal: $_candidateUpdateValue >>> tempCurrentXData: $_tempCurrentXData");
    for (var child in _children) {
      child._printTempInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}
