part of '../core.dart';

class SortableValue extends Equatable {
  final dynamic value;

  const SortableValue.ofString(String? this.value);

  const SortableValue.ofDouble(double? this.value);

  const SortableValue.ofNum(num? this.value);

  const SortableValue.ofInt(int? this.value);

  const SortableValue.ofBool(bool? this.value);

  const SortableValue.ofDateTime(DateTime? this.value);

  const SortableValue.ofComparable(Comparable? this.value);

  @override
  List<Object?> get props => [value];
}
