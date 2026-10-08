part of '../core.dart';

/// Configuration class governing the behavior and operational policies of a Task.
class TaskConfig {
  /// Defines the action to be taken when the task view is hidden.
  final ScalarHiddenAction onHideAction;

  final bool allowReloadInitDataOnFresh;

  /// Determines whether multiple submissions are allowed for the task.
  /// Defaults to [false] to prevent accidental double-submissions.
  final bool allowMultipleSubmissions;

  /// Determines whether the form fields are cleared and reset to their initial empty state
  /// upon a successful submission while remaining on the current view. Defaults to [false].
  final bool resetFormOnSuccess;

  const TaskConfig({
    this.onHideAction = ScalarHiddenAction.none,
    this.allowReloadInitDataOnFresh = false,
    this.allowMultipleSubmissions = false,
    this.resetFormOnSuccess = false,
  });

  /// Creates a copy of this [TaskConfig] with optional overridden parameters.
  TaskConfig copy({
    ScalarHiddenAction? onHideAction,
    bool? allowReloadInitDataOnFresh,
    bool? allowMultipleSubmissions,
    bool? lockFormOnSuccess,
    bool? resetFormOnSuccess,
  }) {
    return TaskConfig(
      onHideAction: onHideAction ?? this.onHideAction,
      allowReloadInitDataOnFresh:
          allowReloadInitDataOnFresh ?? this.allowReloadInitDataOnFresh,
      allowMultipleSubmissions:
          allowMultipleSubmissions ?? this.allowMultipleSubmissions,
      resetFormOnSuccess: resetFormOnSuccess ?? this.resetFormOnSuccess,
    );
  }
}

/// Effective runtime configuration wrapper for a Task, resolving baseline rules
/// and overriding mechanisms.
class TaskEffectiveConfig {
  final TaskConfig _baselineConfig;

  TaskEffectiveConfig._fromConfig(this._baselineConfig);

  /// Creates an [TaskEffectiveConfig] instance from the given baseline [TaskConfig].
  factory TaskEffectiveConfig.fromConfig(TaskConfig config) =>
      TaskEffectiveConfig._fromConfig(config);

  /// Gets the action to be executed when the task view is hidden.
  ScalarHiddenAction get onHideAction => _baselineConfig.onHideAction;

  /// Indicates whether initial data reloading is restricted exclusively to error states.
  bool get allowReloadInitDataOnFresh =>
      _baselineConfig.allowReloadInitDataOnFresh;

  /// Indicates whether multiple submissions are permitted.
  bool get allowMultipleSubmissions => _baselineConfig.allowMultipleSubmissions;

  /// Indicates whether the form fields should be reset/cleared upon a successful submission.
  bool get resetFormOnSuccess => _baselineConfig.resetFormOnSuccess;
}
