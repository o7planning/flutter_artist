part of '_built_in_filter_criteria.dart';

class StringIdFilterInput extends FilterInput {
  final String? idValue;

  const StringIdFilterInput({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
