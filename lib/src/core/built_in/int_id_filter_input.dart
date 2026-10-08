part of '__built_in_model.dart';

class IntIdFilterInput extends FilterInput {
  final int? idValue;

  const IntIdFilterInput({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
