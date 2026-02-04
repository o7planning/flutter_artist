part of '../../core.dart';

///
/// [ConditionDefImpl], [ConditionGroupDefImpl],
///
abstract interface class ConditionDef {
  FilterModelStructure get structure;

  ConditionDef? get group;

  List<ConditionDef> get conditions;

  factory ConditionDef.condition({
    required String criterionNameTilde,
    String? parentModelSuffix,
    required CriterionOperator operator,
    List<CriterionOperator>? supportedOperators,
    DefaultSettingPolicy defaultSettingPolicy =
        DefaultSettingPolicy.onInitialOnly,
  }) {
    return ConditionDefImpl._(
      criterionNameTilde: criterionNameTilde,
      parentModelSuffix: parentModelSuffix,
      operator: operator,
      supportedOperators: supportedOperators,
      defaultSettingPolicy: defaultSettingPolicy,
    );
  }

  factory ConditionDef.group({
    required String groupName,
    required ConditionConnector connector,
    required List<ConditionDef> conditions,
  }) {
    return ConditionGroupDefImpl._(
      groupName: groupName,
      connector: connector,
      conditions: conditions,
    );
  }
}

class ConditionDefImpl implements ConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;

  late final String parentModelSuffix;
  final DefaultSettingPolicy defaultSettingPolicy;
  final CriterionTilde _criterionX;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  //
  String get criterionName => _criterionX.criterionName;

  String get criterionNameTilde => _criterionX.criterionNameTilde;

  String get suffix => _criterionX.suffix;

  late final ConditionGroupDefImpl? __group;
  late final CriterionDef criterionDef;

  @override
  ConditionDef? get group => __group;

  @override
  List<ConditionDef> get conditions => [];

  ConditionDefImpl._({
    required String criterionNameTilde,
    String? parentModelSuffix,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
    required this.defaultSettingPolicy,
  }) : _criterionX = CriterionTilde.parse(
          criterionNameTilde: criterionNameTilde,
        ) {
    this.parentModelSuffix = parentModelSuffix ?? _criterionX.suffix;
    _supportedOperators = supportedOperators == null
        ? [operator]
        : {...supportedOperators, operator}.toList();
  }
}

class ConditionGroupDefImpl implements ConditionDef {
  late final FilterModelStructure _structure;

  @override
  FilterModelStructure get structure => _structure;
  final String groupName;
  final ConditionConnector connector;

  late final ConditionGroupDefImpl? __group;

  @override
  ConditionDef? get group => __group;

  @override
  final List<ConditionDef> conditions;

  ConditionGroupDefImpl._({
    required this.groupName,
    required this.connector,
    required this.conditions,
  }) {
    final Map<String, ConditionDef> map = {};
    for (ConditionDef def in conditions) {
      if (def is ConditionDefImpl) {
        final nameTilde = def._criterionX.criterionNameTilde;
        if (map.containsKey(nameTilde)) {
          throw DuplicateFilterConditionDefError(
            criterionNameTilde: nameTilde,
            groupName: groupName,
          );
        }
        map[nameTilde] = def;
      }
    }
  }
}
