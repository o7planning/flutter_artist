part of '../../core.dart';

///
/// [SimpleCriterionDef], [MultiOptCriterionDef]
///
abstract class CriterionDef<V extends Object> {
  final Set<String> _tildeSuffixes = {};

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
    if (baseValue == null) {
      return null;
    }
    if (baseValue is List) {
      return baseValue.map((e) => __toFieldValue.call(e).value).toList();
    }
    return __toFieldValue.call(baseValue).value;
  }

  void _printDebugTildeSuffixes() {
    print("@@ criterionName: $criterionBaseName --> $_tildeSuffixes");
  }

  void _printDebugTildeSuffixesCascade() {
    _printDebugTildeSuffixes();
    if (this is MultiOptCriterionDef) {
      MultiOptCriterionDef _this = this as MultiOptCriterionDef;
      for (CriterionDef childDef in _this._children) {
        childDef._printDebugTildeSuffixesCascade();
      }
    }
  }
}

class SimpleCriterionDef<V extends Object> extends CriterionDef<V> {
  SimpleCriterionDef({
    required super.criterionBaseName,
    super.fieldName,
    super.toFieldValue,
    super.description,
  }) : super._();

  SimpleTildeFilterCriterionModel<V> createTildeCriterionModel({
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
  }) {
    return SimpleTildeFilterCriterionModel<V>(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
    );
  }
}

class MultiOptCriterionDef<V extends Object> extends CriterionDef<V> {
  late final MultiOptCriterionDef? parent;

  final SelectionType selectionType;

  final List<TildeCriterionConfig> tildeCriterionConfigs;

  // String tildeSuffix -> TildeCriterionConfig.
  final Map<String, TildeCriterionConfig> __tildeCriterionConfigMap = {};

  final List<MultiOptCriterionDef> _children;

  List<MultiOptCriterionDef> get children => List.unmodifiable(_children);

  TildeCriterionConfig findOrCreateTildeCriterionConfig({
    required String tildeSuffix,
  }) {
    TildeCriterionConfig? def = __tildeCriterionConfigMap[tildeSuffix];
    if (def == null) {
      def = TildeCriterionConfig(suffix: tildeSuffix);
      __tildeCriterionConfigMap[tildeSuffix] = def;
    }
    return def;
  }

  MultiOptCriterionDef._({
    required super.criterionBaseName,
    required super.fieldName,
    required super.toFieldValue,
    required super.description,
    required this.tildeCriterionConfigs,
    required List<MultiOptCriterionDef> children,
    required this.selectionType,
  })  : _children = children,
        super._() {
    for (TildeCriterionConfig def in tildeCriterionConfigs) {
      bool value1 = NameUtils.isValidTildeSuffix(def.suffix);
      if (!value1) {
        throw TildeCriterionConfigInvalidSuffixError(
          tildeSuffix: def.suffix,
          criterionBaseName: criterionBaseName,
        );
      }
      bool value2 = NameUtils.isValidTildeSuffix(def.parentMatchSuffix);
      if (!value2) {
        throw TildeCriterionConfigInvalidSuffixError(
          tildeSuffix: def.parentMatchSuffix,
          criterionBaseName: criterionBaseName,
        );
      }
      if (__tildeCriterionConfigMap.containsKey(def.suffix)) {
        throw TildeCriterionConfigDuplicationError(
          tildeSuffix: def.suffix,
          criterionBaseName: criterionBaseName,
        );
      }
      __tildeCriterionConfigMap[def.suffix] = def;
    }
  }

  factory MultiOptCriterionDef.singleSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
    List<MultiOptCriterionDef> children = const [],
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      tildeCriterionConfigs: tildeCriterionConfigs,
      children: children,
      selectionType: SelectionType.single,
    );
  }

  factory MultiOptCriterionDef.multiSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
  }) {
    return MultiOptCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      children: [],
      selectionType: SelectionType.multi,
      tildeCriterionConfigs: tildeCriterionConfigs,
    );
  }

  MultiOptTildeFilterCriterionModel<V> createTildeCriterionModel({
    required MultiOptTildeFilterCriterionModel? parent,
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
    required DefaultSettingPolicy defaultSettingPolicy,
    required String parentMatchSuffix,
  }) {
    return selectionType == SelectionType.single
        ? MultiOptSsTildeFilterCriterionModel<V>(
            tildeCriterionName: tildeCriterionName,
            criterionName: criterionName,
            tildeSuffix: tildeSuffix,
            defaultSettingPolicy: defaultSettingPolicy,
            parentMatchSuffix: parentMatchSuffix,
            parent: parent,
          )
        : MultiOptMsTildeFilterCriterionModel<V>(
            tildeCriterionName: tildeCriterionName,
            criterionName: criterionName,
            tildeSuffix: tildeSuffix,
            defaultSettingPolicy: defaultSettingPolicy,
            parentMatchSuffix: parentMatchSuffix,
            parent: parent,
          );
  }

  void printDebugSuffixes() {
    print("criterionBaseName: $criterionBaseName --> $_tildeSuffixes");
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

  CalculatedTildeFilterCriterionModel<V> createModel({
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
  }) {
    return CalculatedTildeFilterCriterionModel<V>(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
      calculate: () {
        throw UnimplementedError();
      },
    );
  }
}

const String tildeSymbol = "~";

class NameTilde {
  final String tildeCriterionName;
  late final String criterionName;
  late final String afterTildeSuffix;
  late final String tildeSuffix;

  NameTilde.parse({required this.tildeCriterionName}) {
    if (!NameUtils.isValidTildeFilterCriterionName(tildeCriterionName)) {
      throw TildeCriterionNameError(tildeCriterionName: tildeCriterionName);
    }
    List<String> ss = tildeCriterionName.split(tildeSymbol);
    criterionName = ss[0];
    afterTildeSuffix = ss[1];
    tildeSuffix = tildeSymbol + ss[1];
  }

  static String getNameTilde({
    required String baseName,
    required String afterTildeSuffix,
  }) {
    return "$baseName$tildeSymbol$afterTildeSuffix";
  }

  static String createNameTilde({
    required String baseName,
    required String tildeSuffix,
  }) {
    return "$baseName$tildeSuffix";
  }
}

class TildeSuffixObj {
  final String tildeSuffix;
  late final String suffixWithoutTilde;

  TildeSuffixObj.parse({required this.tildeSuffix}) {
    if (!NameUtils.isValidTildeSuffix(tildeSuffix)) {
      throw TildeSuffixError(tildeSuffix: tildeSuffix);
    }
    List<String> ss = tildeSuffix.split(tildeSymbol);
    suffixWithoutTilde = ss[1];
  }
}

class CriterionBaseName {
  final String criterionBaseName;

  CriterionBaseName.parse({required this.criterionBaseName}) {
    if (!NameUtils.isValidFilterCriterionName(criterionBaseName)) {
      throw CriterionBaseNameError(criterionBaseName: criterionBaseName);
    }
  }
}

class FieldName {
  final String fieldName;

  FieldName.parse({required this.fieldName}) {
    if (!NameUtils.isValidFilterFieldName(fieldName)) {
      throw FilterFieldNameError(fieldName: fieldName);
    }
  }
}
