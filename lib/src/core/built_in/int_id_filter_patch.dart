part of '__built_in_model.dart';

class IntIdFilterPatch extends FilterPatch {
  final int? idValue;

  const IntIdFilterPatch({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
