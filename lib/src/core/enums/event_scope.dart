
/// All comments are in English for global users to read.
enum EventScope {
  /// Only handled within the local Shelf that emitted it.
  local,

  /// Handled by the local Shelf first, then broadcasted to all other Shelves.
  global,
}