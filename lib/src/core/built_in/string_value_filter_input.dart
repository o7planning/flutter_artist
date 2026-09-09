import '../_core_/core.dart';

class StringValueFilterInput extends FilterInput {
  final String? stringValue;

  const StringValueFilterInput({required this.stringValue});

  @override
  List<Object?> get props => [stringValue];
}
