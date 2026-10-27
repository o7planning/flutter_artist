part of '../core.dart';

/// An explicit architectural contract for workflow units ([Task] or [Prozess])
/// that are authorized to authenticate a user and establish a global session.
///
/// Implementing this interface signals to the framework execution engine that,
/// upon a successful submission, the resulting user identity must be registered
/// into [GlobalsManager] and global application data must be bootstrapped.
///
/// For security reasons, any class implementing [SessionEstablisher] must also
/// be explicitly whitelisted in the application's [AppConfig].
abstract interface class SessionEstablisher<USER extends ILoggedInUser> {
  /// Extracts the authenticated user payload after the workflow's main submission
  /// operation completes.
  ///
  /// If this method returns `null`, the session establishment phase will be aborted
  /// with an operational error.
  USER? extractAuthenticatedUser();
}
