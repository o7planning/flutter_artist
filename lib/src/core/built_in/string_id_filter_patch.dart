part of '__built_in_model.dart';

class StringIdFilterPatch extends FilterPatch {
  final String? idValue;

  const StringIdFilterPatch({required this.idValue});

  @override
  List<Object?> get props => [idValue];
}
