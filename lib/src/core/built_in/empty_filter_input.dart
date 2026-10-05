part of '_built_in_filter_criteria.dart';

// No subclasses allowed.
class EmptyFilterInput extends FilterInput {
  const EmptyFilterInput._();

  factory EmptyFilterInput() => EmptyFilterInput._();

  @override
  List<Object?> get props => [];
}
