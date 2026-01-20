part of '../../core.dart';

abstract class PropDef<V> {
  final String propName;
  final String? description;

  Type get dataType => V;

  PropDef._({
    required this.propName,
    required this.description,
  }) {
    // Check the validity of the name:
    // CriterionBaseName.parse(propName: propName);
  }
}

class SimplePropDef<V> extends PropDef<V> {
  SimplePropDef({
    required super.propName,
    super.description,
  }) : super._();

  SimpleFormPropModel<V> createModel({
    required String propName,
  }) {
    return SimpleFormPropModel<V>(
      propName: propName,
    );
  }
}

class MultiOptPropDef<V> extends PropDef<V> {
  late final MultiOptPropDef? parent;

  final MultiOptPropReload reloadCondition;

  final SelectionType selectionType;

  final List<MultiOptPropDef> _children;

  List<MultiOptPropDef> get children => List.unmodifiable(_children);

  MultiOptPropDef._({
    required super.propName,
    required super.description,
    required List<MultiOptPropDef> children,
    required this.selectionType,
    required this.reloadCondition,
  })  : _children = [...children],
        super._();

  factory MultiOptPropDef.singleSelection({
    required String propName,
    String? description,
    List<MultiOptPropDef> children = const [],
    MultiOptPropReload reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) {
    return MultiOptPropDef._(
      propName: propName,
      description: description,
      children: children,
      selectionType: SelectionType.single,
      reloadCondition: reloadCondition,
    );
  }

  factory MultiOptPropDef.multiSelection({
    required String propName,
    String? description,
    MultiOptPropReload reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) {
    return MultiOptPropDef._(
      propName: propName,
      description: description,
      children: [],
      selectionType: SelectionType.multi,
      reloadCondition: reloadCondition,
    );
  }

  @override
  MultiOptFormPropModel<V> createModel({
    required MultiOptFormPropModel? parent,
    required String propName,
  }) {
    return selectionType == SelectionType.single
        ? MultiOptSsFormPropModel<V>(
            propName: propName,
            parent: parent,
            reloadCondition: reloadCondition,
          )
        : MultiOptMsFormPropModel<V>(
            propName: propName,
            parent: parent,
            reloadCondition: reloadCondition,
          );
  }
}

class CalculatedPropDef<V> extends PropDef<V> {
  final V Function() calculate;

  CalculatedPropDef({
    required super.propName,
    required this.calculate,
    super.description,
  }) : super._();

  CalculatedFormPropModel<V> createModel({
    required String propName,
  }) {
    return CalculatedFormPropModel<V>(
      propName: propName,
      calculate: () {
        throw UnimplementedError();
      },
    );
  }
}
