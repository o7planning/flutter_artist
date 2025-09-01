import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';

class FilterModelDebugView extends StatelessWidget {
  final FilterModel filterModel;

  const FilterModelDebugView({
    super.key,
    required this.filterModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(filterModel.debugClassDefinition),
          Divider(),
        ],
      ),
    );
  }
}
