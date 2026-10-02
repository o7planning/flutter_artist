part of '../../core.dart';

abstract class FormOutput {
  const FormOutput();
}

class MapBasedFormOutput extends FormOutput {
  final Map<String, dynamic> formMapData;

  const MapBasedFormOutput({required this.formMapData});
}
