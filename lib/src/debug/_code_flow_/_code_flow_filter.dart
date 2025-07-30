import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../enums/_code_flow_item_type.dart';
import '../../widgets/_custom_app_container.dart';
import '../../widgets/_labeled_checkbox.dart';

class CodeFlowFilter extends StatelessWidget {
  final List<CodeFlowItemType> codeFlowItemTypes;

  final bool showDevMethod;

  //
  final bool showPublicMethod;
  final bool showPrivateMethod;

  //
  final bool showInfo;
  final bool showError;

  final Function(bool? value) onShowDevMethodChanged;

  //
  final Function(bool? value) onShowPublicMethodChanged;
  final Function(bool? value) onShowPrivateMethodChanged;

  //
  final Function(bool? value) onShowInfoChanged;
  final Function(bool? value) onShowErrorChanged;

  const CodeFlowFilter({
    required this.codeFlowItemTypes,
    required this.showDevMethod,
    required this.showPublicMethod,
    required this.showPrivateMethod,
    required this.showInfo,
    required this.showError,
    //
    required this.onShowDevMethodChanged,
    required this.onShowPublicMethodChanged,
    required this.onShowPrivateMethodChanged,
    required this.onShowInfoChanged,
    required this.onShowErrorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppContainer(
      width: double.maxFinite,
      child: BreadCrumb(
        divider: _divider(),
        items: [
          BreadCrumbItem(
            content: _buildCheckBox(
              value: showDevMethod,
              label: "Dev Methods",
              tooltip: "Your Dev Methods",
              onChanged: onShowDevMethodChanged,
            ),
          ),
          //
          BreadCrumbItem(
            content: _buildCheckBox(
              value: showPublicMethod,
              label: "Public Lib Methods",
              tooltip: "Public Library Methods",
              onChanged: onShowPublicMethodChanged,
            ),
          ),
          BreadCrumbItem(
            content: _buildCheckBox(
              value: showPrivateMethod,
              label: "Private Lib Methods",
              tooltip: "Private Library Methods",
              onChanged: onShowPrivateMethodChanged,
            ),
          ),
          //
          BreadCrumbItem(
            content: _buildCheckBox(
              value: showInfo,
              label: "Info",
              tooltip: "Info",
              onChanged: onShowInfoChanged,
            ),
          ),
          BreadCrumbItem(
            content: _buildCheckBox(
              value: showError,
              label: "Err",
              tooltip: "Error",
              onChanged: onShowErrorChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(
      height: 20,
      child: VerticalDivider(color: Colors.grey),
    );
  }

  Widget _buildCheckBox({
    required bool value,
    required String label,
    required String tooltip,
    required Function(bool? value) onChanged,
  }) {
    return Tooltip(
      message: tooltip,
      child: LabeledCheckbox(
        value: value,
        label: label,
        labelStyle: const TextStyle(
          fontSize: 13,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
