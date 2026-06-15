part of '../core.dart';

/// Represents a declarative navigation intent that integrates seamlessly
/// with the [FlutterArtistRouter] stack lifecycle.
abstract class NavigationIntent {
  /// Controls whether this intent should still execute if the prior
  /// framework action (Create/Save/Delete) reports a failure.
  final bool executeOnFailure;
  final String name;

  const NavigationIntent._({
    this.executeOnFailure = false,
    required this.name,
  });

  /// Standard intent to push a new path onto the router stack.
  factory NavigationIntent.to(
    String path, {
    FaRouteBuilder? builder,
    Object? extra,
    bool executeOnFailure = false,
  }) {
    return _NavigationToIntent(
      path,
      builder: builder,
      extra: extra,
      executeOnFailure: executeOnFailure,
    );
  }

  /// Standard intent to replace the current route with a new path.
  factory NavigationIntent.off(
    String path, {
    FaRouteBuilder? builder,
    Object? extra,
    bool executeOnFailure = false,
  }) {
    return _NavigationOffIntent(
      path,
      builder: builder,
      extra: extra,
      executeOnFailure: executeOnFailure,
    );
  }

  /// Standard intent to clear the entire stack and navigate to a new root path.
  factory NavigationIntent.offAll(
    String path, {
    FaRouteBuilder? builder,
    Object? extra,
    bool executeOnFailure = false,
  }) {
    return _NavigationOffAllIntent(
      path,
      builder: builder,
      extra: extra,
      executeOnFailure: executeOnFailure,
    );
  }

  /// Standard intent to pop the top-most route (Page or Dialog) from the stack.
  /// Defaults [executeOnFailure] to true so closures can always trigger.
  factory NavigationIntent.pop({
    // required TaskResult result,
    bool executeOnFailure = false,
  }) {
    return _NavigationPopIntent(
      executeOnFailure: executeOnFailure,
    );
  }

  /// Standard intent to overlay a declarative dialog onto the router stack.
  factory NavigationIntent.showDialog(
    String path, {
    required FaRouteBuilder builder,
    List<FaRouteGuard> guards = const [],
    Object? extra,
    bool barrierDismissible = false,
    bool executeOnFailure = false,
  }) {
    return _NavigationShowDialogIntent(
      path,
      builder: builder,
      guards: guards,
      extra: extra,
      barrierDismissible: barrierDismissible,
      executeOnFailure: executeOnFailure,
    );
  }

  /// Standard intent to clean up and close all active [FaDialogPage] routes
  /// while safely preserving the underlying page route.
  factory NavigationIntent.closeAllDialogs({
    bool executeOnFailure = false,
  }) {
    return _NavigationCloseAllDialogsIntent(
      executeOnFailure: executeOnFailure,
    );
  }

  factory NavigationIntent.openDrawer({
    bool executeOnFailure = false,
  }) {
    return _NavigationOpenDrawerIntent(
      executeOnFailure: executeOnFailure,
    );
  }

  factory NavigationIntent.openEndDrawer({
    bool executeOnFailure = false,
  }) {
    return _NavigationOpenEndDrawerIntent(
      executeOnFailure: executeOnFailure,
    );
  }
}
