import '../_core_/core.dart';

class IntIdFilterInput extends FilterInput {
  final int? idValue;

  const IntIdFilterInput({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
