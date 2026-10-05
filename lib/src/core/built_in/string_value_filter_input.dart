part of '_built_in_filter_criteria.dart';

class StringValueFilterInput extends FilterInput {
  final String? stringValue;

  const StringValueFilterInput({required this.stringValue});

  @override
  List<Object?> get props => [stringValue];
}
