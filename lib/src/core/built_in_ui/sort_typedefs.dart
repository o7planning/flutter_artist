import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_enums.dart';

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
