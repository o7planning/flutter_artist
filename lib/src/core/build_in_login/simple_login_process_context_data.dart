part of '_login.dart';

/// Base shared context data for multi-stage authentication workflows.
///
/// Holds the final [authenticatedUser] resolved during the stage sequence and
/// automatically exposes it to the framework's debug inspector views.
/// Developers should extend this class to add intermediate state fields
/// (e.g., temporary MFA tokens,挑战 challenges, or available tenant lists).
abstract class SimpleLoginProzessContextData<USER extends ILoggedInUser>
    extends ProzessContextData {
  /// The fully authenticated user entity, typically populated by the final stage
  /// in the login workflow.
  USER? authenticatedUser;

  /// Subclasses can override this to reset their custom intermediate fields.
  @protected
  void onResetCustomFields();

  @override
  @nonVirtual
  void reset() {
    authenticatedUser = null;
    onResetCustomFields();
  }

  /// Subclasses can override this to append custom intermediate fields to the debug view.
  @protected
  Map<String, dynamic> toCustomDebugMap() => {};

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "authenticatedUser": authenticatedUser,
      ...toCustomDebugMap(),
    };
  }
}
