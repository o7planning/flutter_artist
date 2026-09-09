import '../_core_/core.dart';

class StringIdFilterInput extends FilterInput {
  final String? idValue;

  const StringIdFilterInput({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
