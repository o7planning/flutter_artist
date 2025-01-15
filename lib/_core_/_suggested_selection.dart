part of '../flutter_artist.dart';

class SuggestedSelection<ID> {
  final ID? itemIdStringToSetAsCurrent;

  Map<String, SuggestedSelection> children = {};

  SuggestedSelection({
    required this.itemIdStringToSetAsCurrent,
  });

  SuggestedSelection? findChildDirective(String childBlockName) {
    return children[childBlockName];
  }
}
