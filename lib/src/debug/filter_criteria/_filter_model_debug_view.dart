import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../widgets/_html_info_view.dart';

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
          HtmlInfoView(
            padding: EdgeInsets.symmetric(vertical: 5),
            infoAsHtml:
                "<b>${getClassNameWithoutGenerics(filterModel)}</b><i>${filterModel.debugClassParametersDefinition}</i>",
          ),
          Divider(),
        ],
      ),
    );
  }
}
