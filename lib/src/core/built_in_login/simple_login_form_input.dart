part of '_login.dart';

/// Form input configuration for the SimpleLoginTask.
/// Allows setting an initial username if retrieved from local storage or previous sessions.
class SimpleLoginFormInput extends FormInput {
  final String? initialUsername;

  SimpleLoginFormInput({
    this.initialUsername,
  });

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "initialUsername": initialUsername,
    };
  }
}
