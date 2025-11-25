part of '../core.dart';

class PolymorphismFamily {
  final String familyName;
  final Set<Type> _members;

  Set<Type> get members => Set.unmodifiable(_members);

  PolymorphismFamily({
    required this.familyName,
    required Set<Type> members,
  }) : _members = members;
}
