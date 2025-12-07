part of '../core.dart';

class PolymorphismFamily<ID extends Object> {
  final String familyName;
  final Set<Type> _members;

  Set<Type> get members => Set.unmodifiable(_members);

  PolymorphismFamily({
    required this.familyName,
    required Set<Type> members,
  }) : _members = members;

  void _checkMembers() {
    for (Type type in _members) {
      // print("TYPE runtime: ${type.runtimeType}");
      // var s = type.runtimeType is  Identifiable<ID>;
      // print("$type is Identifiable<$ID>? $s");
    }
  }

  @override
  String toString() {
    // IMPORTANT: Do not change:
    return "${getTypeNameWithoutGenerics(PolymorphismFamily)}('$familyName')";
  }
}
