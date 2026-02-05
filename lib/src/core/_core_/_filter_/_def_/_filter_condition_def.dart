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
    String? parentMatchSuffix,
    required CriterionOperator operator,
    List<CriterionOperator>? supportedOperators,
    DefaultSettingPolicy defaultSettingPolicy =
        DefaultSettingPolicy.onInitialOnly,
  }) {
    return ConditionDefImpl._(
      criterionNameTilde: criterionNameTilde,
      parentMatchSuffix: parentMatchSuffix,
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

  late final String parentMatchSuffix;
  final DefaultSettingPolicy defaultSettingPolicy;
  final NameTilde _nameTilde;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  //
  String get criterionName => _nameTilde.criterionName;

  String get criterionNameTilde => _nameTilde.criterionNameTilde;

  String get afterTildeSuffix => _nameTilde.afterTildeSuffix;

  late final ConditionGroupDefImpl? __group;
  late final CriterionDef criterionDef;

  @override
  ConditionDef? get group => __group;

  @override
  List<ConditionDef> get conditions => [];

  ConditionDefImpl._({
    required String criterionNameTilde,
    String? parentMatchSuffix,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
    required this.defaultSettingPolicy,
  }) : _nameTilde = NameTilde.parse(
          criterionNameTilde: criterionNameTilde,
        ) {
    this.parentMatchSuffix = parentMatchSuffix ?? _nameTilde.afterTildeSuffix;
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
        final nameTilde = def._nameTilde.criterionNameTilde;
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
