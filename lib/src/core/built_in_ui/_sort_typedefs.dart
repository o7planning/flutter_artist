part of '_built_in_ui.dart';

typedef SortCriterionItemBuilder = Widget Function(
  BuildContext context,
  SortCriterion criterion,
  bool isSelected,
  VoidCallback toggleDirection,
);

typedef SortIconBuilder = Widget Function(
  BuildContext context,
  SortDirection? direction,
  bool isDragging,
  double size,
  Color? draggingColor,
);
