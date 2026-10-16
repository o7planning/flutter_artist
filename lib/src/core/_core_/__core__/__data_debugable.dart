part of '../core.dart';

/// Interface implemented by data objects (such as StageInitData, StageResultData, ProzessContextData)
/// to expose a structured map of key-value pairs for debugging and inspection purposes.
abstract interface class DataDebugable {
  Map<String, dynamic> toDebugMap();
}
