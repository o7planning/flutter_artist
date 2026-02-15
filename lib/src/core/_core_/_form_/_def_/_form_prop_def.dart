part of '../../core.dart';

abstract class FormPropDef<V> {
  final String propName;
  final String? description;

  Type get dataType => V;

  FormPropDef._({
    required this.propName,
    required this.description,
  }) {
    // Check the validity of the name:
    // CriterionBaseName.parse(propName: propName);
  }
}

// *****************************************************************************

class SimpleFormPropDef<V> extends FormPropDef<V> {
  SimpleFormPropDef({
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

// *****************************************************************************

class MultiOptFormPropDef<V> extends FormPropDef<V> {
  late final MultiOptFormPropDef? parent;

  final MultiOptPropReload reloadCondition;

  final SelectionType selectionType;

  final List<MultiOptFormPropDef> _children;

  List<MultiOptFormPropDef> get children => List.unmodifiable(_children);

  MultiOptFormPropDef._({
    required super.propName,
    required super.description,
    required List<MultiOptFormPropDef> children,
    required this.selectionType,
    required this.reloadCondition,
  })  : _children = [...children],
        super._();

  factory MultiOptFormPropDef.singleSelection({
    required String propName,
    String? description,
    List<MultiOptFormPropDef> children = const [],
    MultiOptPropReload reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) {
    return MultiOptFormPropDef._(
      propName: propName,
      description: description,
      children: children,
      selectionType: SelectionType.single,
      reloadCondition: reloadCondition,
    );
  }

  factory MultiOptFormPropDef.multiSelection({
    required String propName,
    String? description,
    MultiOptPropReload reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  }) {
    return MultiOptFormPropDef._(
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

// *****************************************************************************

class CalculatedPropDef<V> extends FormPropDef<V> {
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
