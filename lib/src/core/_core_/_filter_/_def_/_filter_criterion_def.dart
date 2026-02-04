part of '../../core.dart';

abstract class CriterionDef<V extends Object> {
  final Set<String> _suffixes = {};

  final String criterionBaseName;
  final String fieldName;
  final String? description;
  final Converter<V>? __toFieldValue;

  bool get toFieldValueProvided => __toFieldValue != null;

  Type get dataType => V;

  bool get isSimpleDataType => SimpleVal.isSimpleDataType(V);

  CriterionDef._({
    required this.criterionBaseName,
    required this.description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
  })  : fieldName = fieldName ?? criterionBaseName,
        __toFieldValue = toFieldValue {
    // Check the validity of the name:
    CriterionBaseName.parse(criterionBaseName: criterionBaseName);
    if (fieldName != null) {
      // Check the validity of the name:
      FieldName.parse(fieldName: fieldName);
    }
    if (!SimpleVal.isSimpleDataType(V) && toFieldValue == null) {
      throw FilterFieldNoConverterError(
        criterionBaseName: criterionBaseName,
        dataType: dataType,
      );
    }
  }

  Object? _convert(V? baseValue) {
    if (__toFieldValue == null) {
      final isSimple = SimpleVal.isSimpleValue(baseValue);
      if (isSimple) {
        return baseValue;
      }
      // Never run.
      throw AppError(
        errorMessage: "The '$dataType' is not simple data type, "
            "you need to provide the toFieldValue() function to convert it to a simple data type.",
      );
    }
    return __toFieldValue.call(baseValue).value;
  }
}

class SimpleCriterionDef<V extends Object> extends CriterionDef<V> {
  SimpleCriterionDef({
    required super.criterionBaseName,
    super.fieldName,
    super.toFieldValue,
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

class MultiOptCriterionDef<V extends Object> extends CriterionDef<V> {
  late final MultiOptCriterionDef? parent;

  final SelectionType selectionType;

  final List<MultiOptCriterionDef> _children;

  List<MultiOptCriterionDef> get children => List.unmodifiable(_children);

  MultiOptCriterionDef._({
    required super.criterionBaseName,
    required super.fieldName,
    required super.toFieldValue,
    required super.description,
    required List<MultiOptCriterionDef> children,
    required this.selectionType,
  })  : _children = children,
        super._();

  factory MultiOptCriterionDef.singleSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
    List<MultiOptCriterionDef> children = const [],
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      children: children,
      selectionType: SelectionType.single,
    );
  }

  factory MultiOptCriterionDef.multiSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
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

class CalculatedCriterionDef<V extends Object> extends CriterionDef<V> {
  final V Function() calculate;

  CalculatedCriterionDef({
    required super.criterionBaseName,
    required this.calculate,
    required super.fieldName,
    required super.toFieldValue,
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

class FieldName {
  final String fieldName;

  FieldName.parse({required this.fieldName}) {
    List<String> ss = fieldName.split(CriterionTilde.symbol);
    if (ss.length != 1) {
      throw FilterFieldNameError(fieldName: fieldName);
    }
    String cn = ss[0];
    if (cn.trim() != cn || cn.trim().isEmpty) {
      throw FilterFieldNameError(fieldName: fieldName);
    }
  }
}
