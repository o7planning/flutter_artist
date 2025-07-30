import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';

class FilterModelDebugView extends StatelessWidget {
  final FilterModel filterModel;

  const FilterModelDebugView({
    super.key,
    required this.filterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Text("OK filterModel");
  }
}
