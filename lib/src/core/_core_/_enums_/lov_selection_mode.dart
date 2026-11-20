part of '_enums.dart';

/// Defines how items can be selected inside a [LovModel].
enum LovSelectionMode {
  /// Only a single item can be selected at a time (classic Oracle Forms LOV behavior).
  single,

  /// Multiple items can be selected simultaneously (checkbox / multi-pick LOV).
  multiple,
}