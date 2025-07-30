part of '../../_fa_core.dart';

class SuggestedSelection<ID> {
  final ID? itemIdToSetAsCurrent;

  Map<String, SuggestedSelection> children = {};

  SuggestedSelection({
    required this.itemIdToSetAsCurrent,
  });

  SuggestedSelection? findChildDirective(String childBlockName) {
    return children[childBlockName];
  }
}
