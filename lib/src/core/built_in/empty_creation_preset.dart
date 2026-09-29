import '../_core_/core.dart';

// No subclasses allowed.
class EmptyCreationPreset extends CreationPreset {
  EmptyCreationPreset._();

  factory EmptyCreationPreset() => EmptyCreationPreset._();
}
