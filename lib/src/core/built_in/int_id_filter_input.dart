part of '_built_in_filter_criteria.dart';

class IntIdFilterInput extends FilterInput {
  final int? idValue;

  const IntIdFilterInput({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
