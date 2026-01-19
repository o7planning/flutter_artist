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
    required String criterionNameTilde,
    required String criterionName,
  }) {
    return SimpleFilterCriterionModel<V>(
      criterionNameTilde: criterionNameTilde,
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
    required String criterionNameTilde,
    required String criterionName,
  }) {
    return selectionType == SelectionType.single
        ? MultiOptSsFilterCriterionModel<V>(
            criterionNameTilde: criterionNameTilde,
            criterionName: criterionName,
            parent: parent,
          )
        : MultiOptMsFilterCriterionModel<V>(
            criterionNameTilde: criterionNameTilde,
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
    required String criterionNameTilde,
    required String criterionName,
  }) {
    return CalculatedFilterCriterionModel<V>(
      criterionNameTilde: criterionNameTilde,
      criterionName: criterionName,
      calculate: () {
        throw UnimplementedError();
      },
    );
  }
}

class CriterionTilde {
  static const String symbol = "~";
  final String criterionNameTilde;
  late final String criterionName;
  late final String? suffix;

  CriterionTilde.parse({required this.criterionNameTilde}) {
    List<String> ss = criterionNameTilde.split(symbol);
    if (ss.length != 2) {
      throw CriterionNameTildeError(criterionNameTilde: criterionNameTilde);
    }
    String cn = ss[0];
    String sf = ss[1];
    if (sf.trim() != sf) {
      throw CriterionNameTildeError(criterionNameTilde: criterionNameTilde);
    }
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionNameTildeError(criterionNameTilde: criterionNameTilde);
    }
    criterionName = cn;
    suffix = sf;
  }

  static String getNameTilde({
    required String baseName,
    required String suffix,
  }) {
    return "$baseName$symbol$suffix";
  }
}

class CriterionBaseName {
  final String criterionBaseName;

  CriterionBaseName.parse({required this.criterionBaseName}) {
    List<String> ss = criterionBaseName.split(CriterionTilde.symbol);
    if (ss.length != 1) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
    String cn = ss[0];
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
  }
}
