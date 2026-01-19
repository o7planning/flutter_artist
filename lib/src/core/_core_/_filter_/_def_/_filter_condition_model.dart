part of '../../core.dart';

abstract class ConditionModel<V> {
  final String criterionNameX;

  Type get dataType => V;

  ConditionModel._({
    required this.criterionNameX,
  });
}

class SimpleConditionModel<V> extends ConditionModel<V> {
  SimpleConditionModel({
    required super.criterionNameX,
  }) : super._();
}

class MultiOptConditionModel<V> extends ConditionModel<V> {
  late final MultiOptConditionModel? parent;

  final List<MultiOptConditionModel> _children = [];

  List<MultiOptConditionModel> get children => List.unmodifiable(_children);

  MultiOptConditionModel({
    required super.criterionNameX,
  }) : super._();
}

class CalculatedConditionModel<V> extends ConditionModel<V> {
  final V Function() calculate;

  CalculatedConditionModel({
    required super.criterionNameX,
    required this.calculate,
  }) : super._();
}
