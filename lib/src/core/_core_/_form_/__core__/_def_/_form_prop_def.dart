part of '../../../core.dart';

///
/// [PlainFormPropDef], [ManagedOptFormPropDef].
///
abstract class FormPropDef<V> {
  final String propName;
  final String? description;

  Type get dataType => V;

  FormPropDef._({
    required this.propName,
    required this.description,
  }) {
    // Check the validity of the name:
    FormPropNameObj.parse(propName: propName);
  }
}

// *****************************************************************************

class PlainFormPropDef<V> extends FormPropDef<V> {
  PlainFormPropDef({
    required super.propName,
    super.description,
  }) : super._();

  PlainFormPropModel<V> createModel({
    required String propName,
  }) {
    return PlainFormPropModel<V>(
      propName: propName,
    );
  }
}

// *****************************************************************************

class ManagedOptFormPropDef<V> extends FormPropDef<V> {
  late final ManagedOptFormPropDef? parent;

  final ManagedOptPropReload reloadCondition;

  final ManagedOptSelectionMode selectionMode;

  final List<ManagedOptFormPropDef> _children;

  List<ManagedOptFormPropDef> get children => List.unmodifiable(_children);

  ManagedOptFormPropDef._({
    required super.propName,
    required super.description,
    required List<ManagedOptFormPropDef> children,
    required this.selectionMode,
    required this.reloadCondition,
  })
      : _children = [...children],
        super._();

  factory ManagedOptFormPropDef.singleSelection({
    required String propName,
    String? description,
    List<ManagedOptFormPropDef> children = const [],
    ManagedOptPropReload reloadCondition = ManagedOptPropReload.ifCriteriaChanged,
    String? nextPropName,
  }) {
    return ManagedOptFormPropDef._(
      propName: propName,
      description: description,
      children: children,
      selectionMode: ManagedOptSelectionMode.single,
      reloadCondition: reloadCondition,
    );
  }

  factory ManagedOptFormPropDef.multiSelection({
    required String propName,
    String? description,
    ManagedOptPropReload reloadCondition = ManagedOptPropReload.ifCriteriaChanged,
    String? nextPropName,
  }) {
    return ManagedOptFormPropDef._(
      propName: propName,
      description: description,
      children: [],
      selectionMode: ManagedOptSelectionMode.multi,
      reloadCondition: reloadCondition,
    );
  }

  ManagedOptFormPropModel<V> createModel({
    required ManagedOptFormPropModel? parent,
    required String propName,
  }) {
    return selectionMode == ManagedOptSelectionMode.single
        ? ManagedOptSsFormPropModel<V>(
      propName: propName,
      parent: parent,
      reloadCondition: reloadCondition,
    )
        : ManagedOptMsFormPropModel<V>(
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
        throw UnimplementedError("CalculatedPropDef");
      },
    );
  }
}
