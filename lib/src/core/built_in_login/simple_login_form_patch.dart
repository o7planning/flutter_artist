part of '_login.dart';

/// Form input configuration for the SimpleLoginTask.
/// Allows setting an initial username if retrieved from local storage or previous sessions.
class SimpleLoginFormPatch extends FormPatch {
  final String? initialUsername;

  SimpleLoginFormPatch({
    this.initialUsername,
  });

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "initialUsername": initialUsername,
    };
  }
}
