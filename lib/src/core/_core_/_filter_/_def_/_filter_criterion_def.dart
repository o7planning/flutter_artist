part of '../../core.dart';

abstract class CriterionDef<V> {
  final Set<String> _suffixes = {};

  final String criterionBaseName;
  final String? description;

  Type get dataType => V;

  CriterionDef._({
    required this.criterionBaseName,
    required this.description,
  }) {
    // Check the validity of the name:
    CriterionBaseName.parse(criterionBaseName: criterionBaseName);
  }
}

class SimpleCriterionDef<V> extends CriterionDef<V> {
  SimpleCriterionDef({
    required super.criterionBaseName,
    super.description,
  }) : super._();

  SimpleFilterCriterionModel<V> createModel({
    required String criterionNameX,
    required String criterionName,
  }) {
    return SimpleFilterCriterionModel<V>(
      criterionNameX: criterionNameX,
      criterionName: criterionName,
    );
  }
}

class MultiOptCriterionDef<V> extends CriterionDef<V> {
  late final MultiOptCriterionDef? parent;

  final SelectionType selectionType;

  final List<MultiOptCriterionDef> _children;

  List<MultiOptCriterionDef> get children => List.unmodifiable(_children);

  MultiOptCriterionDef._({
    required super.criterionBaseName,
    required super.description,
    required List<MultiOptCriterionDef> children,
    required this.selectionType,
  })  : _children = children,
        super._();

  factory MultiOptCriterionDef.singleSelection({
    required String criterionBaseName,
    String? description,
    List<MultiOptCriterionDef> children = const [],
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      description: description,
      children: children,
      selectionType: SelectionType.single,
    );
  }

  factory MultiOptCriterionDef.multiSelection({
    required String criterionBaseName,
    String? description,
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      description: description,
      children: [],
      selectionType: SelectionType.multi,
    );
  }

  @override
  MultiOptFilterCriterionModel<V> createModel({
    required MultiOptFilterCriterionModel? parent,
    required String criterionNameX,
    required String criterionName,
  }) {
    return selectionType == SelectionType.single
        ? MultiOptSsFilterCriterionModel<V>(
            criterionNameX: criterionNameX,
            criterionName: criterionName,
            parent: parent,
          )
        : MultiOptMsFilterCriterionModel<V>(
            criterionNameX: criterionNameX,
            criterionName: criterionName,
            parent: parent,
          );
  }
}

class CalculatedCriterionDef<V> extends CriterionDef<V> {
  final V Function() calculate;

  CalculatedCriterionDef({
    required super.criterionBaseName,
    required this.calculate,
    super.description,
  }) : super._();

  CalculatedFilterCriterionModel<V> createModel({
    required String criterionNameX,
    required String criterionName,
  }) {
    return CalculatedFilterCriterionModel<V>(
      criterionNameX: criterionNameX,
      criterionName: criterionName,
      calculate: () {
        throw UnimplementedError();
      },
    );
  }
}

class CriterionX {
  static const String symbol = "~";
  final String criterionNameX;
  late final String criterionName;
  late final String? suffix;

  CriterionX.parse({required this.criterionNameX}) {
    List<String> ss = criterionNameX.split(symbol);
    if (ss.length != 2) {
      throw CriterionNameXError(criterionNameX: criterionNameX);
    }
    String cn = ss[0];
    String sf = ss[1];
    if (sf.trim() != sf) {
      throw CriterionNameXError(criterionNameX: criterionNameX);
    }
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionNameXError(criterionNameX: criterionNameX);
    }
    criterionName = cn;
    suffix = sf;
  }

  static String getNameX({
    required String baseName,
    required String suffix,
  }) {
    return "$baseName$symbol$suffix";
  }
}

class CriterionBaseName {
  final String criterionBaseName;

  CriterionBaseName.parse({required this.criterionBaseName}) {
    List<String> ss = criterionBaseName.split(CriterionX.symbol);
    if (ss.length != 1) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
    String cn = ss[0];
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
  }
}
