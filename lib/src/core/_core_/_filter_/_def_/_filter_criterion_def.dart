part of '../../core.dart';

///
/// [SimpleFilterCriterionDef], [MultiOptFilterCriterionDef]
///
abstract class FilterCriterionDef<V extends Object> {
  final Set<String> _tildeSuffixes = {};

  final String criterionBaseName;
  final String fieldName;
  final String? description;
  final Converter<V>? __toFieldValue;

  bool get toFieldValueProvided => __toFieldValue != null;

  Type get dataType => V;

  bool get isSimpleDataType => SimpleVal.isSimpleDataType(V);

  FilterCriterionDef._({
    required this.criterionBaseName,
    required this.description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
  })  : fieldName = fieldName ?? criterionBaseName,
        __toFieldValue = toFieldValue {
    // Check the validity of the name:
    FilterCriterionNameObj.parse(criterionBaseName: criterionBaseName);
    if (fieldName != null) {
      // Check the validity of the name:
      FilterFieldNameObj.parse(fieldName: fieldName);
    }
    if (!SimpleVal.isSimpleDataType(V) && toFieldValue == null) {
      throw FilterCriterionNoFieldValueConverterError(
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
    if (this is MultiOptFilterCriterionDef) {
      MultiOptFilterCriterionDef _this = this as MultiOptFilterCriterionDef;
      for (FilterCriterionDef childDef in _this._children) {
        childDef._printDebugTildeSuffixesCascade();
      }
    }
  }
}

// *****************************************************************************

class SimpleFilterCriterionDef<V extends Object> extends FilterCriterionDef<V> {
  SimpleFilterCriterionDef({
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

// *****************************************************************************

class MultiOptFilterCriterionDef<V extends Object>
    extends FilterCriterionDef<V> {
  late final MultiOptFilterCriterionDef? parent;

  final SelectionType selectionType;

  final List<TildeCriterionConfig> tildeCriterionConfigs;

  // String tildeSuffix -> TildeCriterionConfig.
  final Map<String, TildeCriterionConfig> __tildeCriterionConfigMap = {};

  final List<MultiOptFilterCriterionDef> _children;

  List<MultiOptFilterCriterionDef> get children => List.unmodifiable(_children);

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

  MultiOptFilterCriterionDef._({
    required super.criterionBaseName,
    required super.fieldName,
    required super.toFieldValue,
    required super.description,
    required this.tildeCriterionConfigs,
    required List<MultiOptFilterCriterionDef> children,
    required this.selectionType,
  })  : _children = children,
        super._() {
    for (TildeCriterionConfig config in tildeCriterionConfigs) {
      bool value1 = NameUtils.isValidTildeSuffix(config.suffix);
      if (!value1) {
        throw TildeCriterionConfigInvalidSuffixError(
          tildeSuffix: config.suffix,
          criterionBaseName: criterionBaseName,
        );
      }
      bool value2 = NameUtils.isValidTildeSuffix(config.parentMatchSuffix);
      if (!value2) {
        throw TildeCriterionConfigInvalidSuffixError(
          tildeSuffix: config.parentMatchSuffix,
          criterionBaseName: criterionBaseName,
        );
      }
      if (__tildeCriterionConfigMap.containsKey(config.suffix)) {
        throw TildeCriterionConfigDuplicationSuffixError(
          tildeSuffix: config.suffix,
          criterionBaseName: criterionBaseName,
        );
      }
      __tildeCriterionConfigMap[config.suffix] = config;
    }
  }

  factory MultiOptFilterCriterionDef.singleSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
    List<MultiOptFilterCriterionDef> children = const [],
  }) {
    return MultiOptFilterCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      tildeCriterionConfigs: tildeCriterionConfigs,
      children: children,
      selectionType: SelectionType.single,
    );
  }

  factory MultiOptFilterCriterionDef.multiSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required Converter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
  }) {
    return MultiOptFilterCriterionDef._(
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

class CalculatedCriterionDef<V extends Object> extends FilterCriterionDef<V> {
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
