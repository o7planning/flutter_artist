part of '__built_in_model.dart';

class StringValueFilterPatch extends FilterPatch {
  final String? stringValue;

  const StringValueFilterPatch({required this.stringValue});

  @override
  List<Object?> get props => [stringValue];
}
