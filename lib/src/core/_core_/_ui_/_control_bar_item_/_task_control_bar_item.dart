part of '../../core.dart';

class TaskControlBarItem extends ControlBarItem<Task, TaskControlBarItemType> {
  const TaskControlBarItem.standard(super.type) : super.standard();

  const TaskControlBarItem.divider()
      : super.standard(TaskControlBarItemType.divider);

  const TaskControlBarItem.back() : super.standard(TaskControlBarItemType.back);

  const TaskControlBarItem.loadInitData()
      : super.standard(TaskControlBarItemType.loadInitData);

  const TaskControlBarItem.submit()
      : super.standard(TaskControlBarItemType.submit);

  TaskControlBarItem.custom({
    required super.tooltip,
    required super.iconData,
    required super.onPressed,
  }) : super.custom();
}
