part of '../core.dart';

/// Base abstract class defining screen-level navigation intents for a specific
/// UI component context (e.g., Main Screen, Dialog, or EndDrawer).
///
/// Subclasses override the relevant intent getters or pass intents via
/// constructor parameters to dictate post-action navigation behavior.
abstract class ScreenNavigationContext {
  const ScreenNavigationContext();
}

class FilterScreenNavigationContext extends ScreenNavigationContext {
  // TODO.
}

// *****************************************************************************

/// Defines navigation intents for [Block] and [BlockFormModel] operations
/// within a specific screen, dialog, or drawer context.
///
/// Can be used directly via constructor parameters or subclassed for reuse:
/// ```dart
/// class MainScreenProductBlockSNC extends BlockScreenNavigationContext {
///   const MainScreenProductBlockSNC();
///
///   @override
///   NavigationIntent? get createNavigationIntent =>
///       NavigationIntent.to('/product-detail');
/// }
/// ```
class BlockScreenNavigationContext extends ScreenNavigationContext {
  final NavigationIntent? _createNavigationIntent;
  final NavigationIntent? _editNavigationIntent;
  final NavigationIntent? _deleteNavigationIntent;
  final NavigationIntent? _saveNavigationIntent;

  const BlockScreenNavigationContext({
    NavigationIntent? createNavigationIntent,
    NavigationIntent? editNavigationIntent,
    NavigationIntent? deleteNavigationIntent,
    NavigationIntent? saveNavigationIntent,
  })  : _createNavigationIntent = createNavigationIntent,
        _editNavigationIntent = editNavigationIntent,
        _deleteNavigationIntent = deleteNavigationIntent,
        _saveNavigationIntent = saveNavigationIntent;

  /// Intent executed after `block.prepareFormToCreateItem()` completes.
  NavigationIntent? get createNavigationIntent => _createNavigationIntent;

  /// Intent executed after `block._prepareFormToEditCurrentItem()` completes.
  NavigationIntent? get editNavigationIntent => _editNavigationIntent;

  /// Intent executed after `block.deleteCurrentItem()` completes.
  NavigationIntent? get deleteNavigationIntent => _deleteNavigationIntent;

  /// Intent executed after `block.formModel.saveForm()` completes.
  NavigationIntent? get saveNavigationIntent => _saveNavigationIntent;
}

// *****************************************************************************

/// Defines navigation intents for [Scalar] operations within a specific screen context.
class ScalarScreenNavigationContext extends ScreenNavigationContext {
  final NavigationIntent? _queryNavigationIntent;

  const ScalarScreenNavigationContext({
    NavigationIntent? queryNavigationIntent,
  }) : _queryNavigationIntent = queryNavigationIntent;

  /// Intent executed after `scalar.query()` completes.
  NavigationIntent? get queryNavigationIntent => _queryNavigationIntent;
}

// *****************************************************************************

/// Defines navigation intents for standalone [Task] operations within a specific
/// screen, dialog, or drawer context.
class TaskScreenNavigationContext extends ScreenNavigationContext {
  final NavigationIntent? _submitNavigationIntent;
  final NavigationIntent? _restartNavigationIntent;

  const TaskScreenNavigationContext({
    NavigationIntent? submitNavigationIntent,
    NavigationIntent? restartNavigationIntent,
  })  : _submitNavigationIntent = submitNavigationIntent,
        _restartNavigationIntent = restartNavigationIntent;

  /// Intent executed after `task.submit()` completes.
  NavigationIntent? get submitNavigationIntent => _submitNavigationIntent;

  /// Intent executed after `task.restart()` completes.
  NavigationIntent? get restartNavigationIntent => _restartNavigationIntent;
}

// *****************************************************************************

/// Defines navigation intents for [Prozess] and [Stage] operations within a
/// specific screen, dialog, or drawer context.
class ProzessScreenNavigationContext extends ScreenNavigationContext {
  final NavigationIntent? _submitViewingStageNavigationIntent;
  final NavigationIntent? _cancelNavigationIntent;

  const ProzessScreenNavigationContext({
    NavigationIntent? submitViewingStageNavigationIntent,
    NavigationIntent? cancelNavigationIntent,
  })  : _submitViewingStageNavigationIntent =
            submitViewingStageNavigationIntent,
        _cancelNavigationIntent = cancelNavigationIntent;

  /// Intent executed after `prozess.submitViewingStage()` completes.
  NavigationIntent? get submitViewingStageNavigationIntent =>
      _submitViewingStageNavigationIntent;

  /// Intent executed after `prozess.cancel()` completes.
  NavigationIntent? get cancelNavigationIntent => _cancelNavigationIntent;
}
