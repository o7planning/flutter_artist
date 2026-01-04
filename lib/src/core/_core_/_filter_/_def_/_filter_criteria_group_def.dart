part of '../../core.dart';

class FilterCriteriaGroupDef implements FilterGroupMemberDef {
  final String groupName;
  final Conjunction conjunction;
  final List<FilterGroupMemberDef> members;

  const FilterCriteriaGroupDef({
    required this.groupName,
    required this.conjunction,
    required this.members,
  });
}
