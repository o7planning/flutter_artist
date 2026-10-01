part of '../core.dart';

class ActivityStructure {
  final ActivityConfig _config;
  final String? description;
  final List<Prozess> prozesses;
  final List<Task> tasks;

  ActivityStructure({
    ActivityConfig config = const ActivityConfig(),
    this.description,
    this.prozesses = const [],
    this.tasks = const [],
  }) : _config = config;
}
