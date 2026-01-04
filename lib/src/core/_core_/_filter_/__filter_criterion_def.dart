part of '../core.dart';

abstract class FilterCriterionDef<V> {
  final String criterionBaseName;
  final String? description;

  Type get dataType => V;

  FilterCriterionDef({
    required this.criterionBaseName,
    required this.description,
  }) {
    // Check the validity of the name:
    CriterionBaseName.parse(criterionBaseName: criterionBaseName);
  }
}

class SimpleFilterCriterionDef<V> extends FilterCriterionDef<V> {
  SimpleFilterCriterionDef({
    required super.criterionBaseName,
    super.description,
  });

  SimpleFilterCriterionModel<V> createModel({
    required String criterionNamePlus,
    required CriterionOperator operator,
  }) {
    return SimpleFilterCriterionModel<V>(
      criterionNamePlus: criterionNamePlus,
    );
  }
}

abstract class MultiOptFilterCriterionDef<V> extends FilterCriterionDef<V> {
  late final MultiOptFilterCriterionDef? parent;

  final SelectionType selectionType;

  final List<MultiOptFilterCriterionDef> _children;

  List<MultiOptFilterCriterionDef> get children => List.unmodifiable(_children);

  MultiOptFilterCriterionDef._({
    required super.criterionBaseName,
    required super.description,
    required List<MultiOptFilterCriterionDef> children,
    required this.selectionType,
  }) : _children = children;

  MultiOptFilterCriterionModel<V> createModel({
    required String criterionNamePlus,
  });
}

class MultiOptMsFilterCriterionDef<V> extends MultiOptFilterCriterionDef<V> {
  MultiOptMsFilterCriterionDef({
    required super.criterionBaseName,
    super.description,
  }) : super._(selectionType: SelectionType.multi, children: const []);

  @override
  MultiOptMsFilterCriterionModel<V> createModel({
    required String criterionNamePlus,
  }) {
    return MultiOptMsFilterCriterionModel<V>(
      criterionNamePlus: criterionNamePlus,
    );
  }
}

class MultiOptSsFilterCriterionDef<V> extends MultiOptFilterCriterionDef<V> {
  MultiOptSsFilterCriterionDef({
    required super.criterionBaseName,
    super.description,
    super.children = const [],
  }) : super._(selectionType: SelectionType.single);

  @override
  MultiOptSsFilterCriterionModel<V> createModel({
    required String criterionNamePlus,
  }) {
    return MultiOptSsFilterCriterionModel<V>(
      criterionNamePlus: criterionNamePlus,
    );
  }
}

class CalculatedFilterCriterionDef<V> extends FilterCriterionDef<V> {
  final V Function() calculate;

  CalculatedFilterCriterionDef({
    required super.criterionBaseName,
    required this.calculate,
    super.description,
  });

  CalculatedFilterCriterionModel<V> createModel({
    required String criterionNamePlus,
    required CriterionOperator operator,
  }) {
    return CalculatedFilterCriterionModel<V>(
      criterionNamePlus: criterionNamePlus,
      calculate: () {
        throw UnimplementedError();
      },
    );
  }
}

class CriterionPlus {
  final String criterionNamePlus;
  late final String criterionName;
  late final String? suffix;

  CriterionPlus.parse({required this.criterionNamePlus}) {
    List<String> ss = criterionNamePlus.split("+");
    if (ss.length != 2) {
      throw CriterionNamePlusError(criterionNamePlus: criterionNamePlus);
    }
    String cn = ss[0];
    String sf = ss[1];
    if (sf.trim() != sf) {
      throw CriterionNamePlusError(criterionNamePlus: criterionNamePlus);
    }
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionNamePlusError(criterionNamePlus: criterionNamePlus);
    }
    criterionName = cn;
    suffix = sf;
  }
}

class CriterionBaseName {
  final String criterionBaseName;

  CriterionBaseName.parse({required this.criterionBaseName}) {
    List<String> ss = criterionBaseName.split("+");
    if (ss.length != 1) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
    String cn = ss[0];
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
  }
}
