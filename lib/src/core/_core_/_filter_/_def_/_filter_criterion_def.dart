part of '../../core.dart';

///
/// [PlainFilterCriterionDef], [ManagedOptFilterCriterionDef]
///
abstract class FilterCriterionDef<V extends Object> {
  final Set<String> _tildeSuffixes = {};

  final String criterionBaseName;
  final String fieldName;
  final String? description;
  final SimpleValConverter<V>? __toFieldValue;

  bool get toFieldValueProvided => __toFieldValue != null;

  Type get dataType => V;

  bool get isSimpleDataType => SimpleVal.isSimpleDataType(V);

  FilterCriterionDef._({
    required this.criterionBaseName,
    required this.description,
    required String? fieldName,
    required SimpleValConverter<V>? toFieldValue,
  })
      : fieldName = fieldName ?? criterionBaseName,
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
      return baseValue.map((e) =>
      __toFieldValue
          .call(e)
          .value).toList();
    }
    return __toFieldValue
        .call(baseValue)
        .value;
  }

  void _printDebugTildeSuffixes() {
    print("@@ criterionName: $criterionBaseName --> $_tildeSuffixes");
  }

  void _printDebugTildeSuffixesCascade() {
    _printDebugTildeSuffixes();
    if (this is ManagedOptFilterCriterionDef) {
      ManagedOptFilterCriterionDef _this = this as ManagedOptFilterCriterionDef;
      for (FilterCriterionDef childDef in _this._children) {
        childDef._printDebugTildeSuffixesCascade();
      }
    }
  }
}

// *****************************************************************************

class PlainFilterCriterionDef<V extends Object> extends FilterCriterionDef<V> {
  PlainFilterCriterionDef({
    required super.criterionBaseName,
    super.fieldName,
    super.toFieldValue,
    super.description,
  }) : super._();

  PlainTildeFilterCriterionModel<V> createTildeCriterionModel({
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
  }) {
    return PlainTildeFilterCriterionModel<V>(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
    );
  }
}

// *****************************************************************************

class ManagedOptFilterCriterionDef<V extends Object>
    extends FilterCriterionDef<V> {
  late final ManagedOptFilterCriterionDef? parent;

  final ManagedOptSelectionMode selectionMode;

  final List<TildeCriterionConfig> tildeCriterionConfigs;

  // String tildeSuffix -> TildeCriterionConfig.
  final Map<String, TildeCriterionConfig> __tildeCriterionConfigMap = {};

  final List<ManagedOptFilterCriterionDef> _children;

  List<ManagedOptFilterCriterionDef> get children => List.unmodifiable(_children);

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

  ManagedOptFilterCriterionDef._({
    required super.criterionBaseName,
    required super.fieldName,
    required super.toFieldValue,
    required super.description,
    required this.tildeCriterionConfigs,
    required List<ManagedOptFilterCriterionDef> children,
    required this.selectionMode,
  })
      : _children = children,
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

  factory ManagedOptFilterCriterionDef.singleSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required SimpleValConverter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
    List<ManagedOptFilterCriterionDef> children = const [],
  }) {
    return ManagedOptFilterCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      tildeCriterionConfigs: tildeCriterionConfigs,
      children: children,
      selectionMode: ManagedOptSelectionMode.single,
    );
  }

  factory ManagedOptFilterCriterionDef.multiSelection({
    required String criterionBaseName,
    String? description,
    required String? fieldName,
    required SimpleValConverter<V>? toFieldValue,
    List<TildeCriterionConfig> tildeCriterionConfigs = const [],
  }) {
    return ManagedOptFilterCriterionDef._(
      criterionBaseName: criterionBaseName,
      fieldName: fieldName,
      toFieldValue: toFieldValue,
      description: description,
      children: [],
      selectionMode: ManagedOptSelectionMode.multi,
      tildeCriterionConfigs: tildeCriterionConfigs,
    );
  }

  ManagedOptTildeFilterCriterionModel<V> createTildeCriterionModel({
    required ManagedOptTildeFilterCriterionModel? parent,
    required String tildeCriterionName,
    required String criterionName,
    required String tildeSuffix,
    required DefaultSettingPolicy defaultSettingPolicy,
    required String parentMatchSuffix,
  }) {
    return selectionMode == ManagedOptSelectionMode.single
        ? ManagedOptSsTildeFilterCriterionModel<V>(
      tildeCriterionName: tildeCriterionName,
      criterionName: criterionName,
      tildeSuffix: tildeSuffix,
      defaultSettingPolicy: defaultSettingPolicy,
      parentMatchSuffix: parentMatchSuffix,
      parent: parent,
    )
        : ManagedOptMsTildeFilterCriterionModel<V>(
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
        throw UnimplementedError("CalculatedTildeFilterCriterionModel");
      },
    );
  }
}
