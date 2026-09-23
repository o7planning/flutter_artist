part of '../core.dart';

class ActivityStructure {
  final ActivityConfig _config;
  final String? description;
  final List<Flow> flows;
  final List<Task> tasks;

  ActivityStructure({
    ActivityConfig config = const ActivityConfig(),
    this.description,
    this.flows = const [],
    this.tasks = const [],
  }) : _config = config;
}
