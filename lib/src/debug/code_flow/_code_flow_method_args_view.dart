import 'package:flutter/material.dart';

import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_simple_accordion.dart';
import '../../core/widgets/_simple_accordion_section.dart';
import '__task_flow_const.dart';

class CodeFlowMethodArgsView extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const CodeFlowMethodArgsView({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Arguments:",
          style: codeStyle(context, isBold: true),
        ),
        const SizedBox(height: 5),
        if (arguments == null || arguments!.isEmpty) _buildEmptyArgs(context),
        if (arguments != null && arguments!.isNotEmpty) _buildArgs(context),
      ],
    );
  }

  Widget _buildEmptyArgs(BuildContext context) {
    return Text(
      " - No Arguments",
      style: codeStyle(context, isBold: false),
    );
  }

  Widget _buildArgNameAndType(
      BuildContext context, MapEntry<String, dynamic> argEntry) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          argEntry.key,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _getArgValueType(argEntry.value),
            textAlign: TextAlign.end,
            style: TextStyle(
              color: argEntry.value == null
                  ? colorScheme.error.withValues(alpha: 0.7)
                  : colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              fontFamily: 'Courier',
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildContentArgValue(
      BuildContext context, MapEntry<String, dynamic> argEntry) {
    dynamic value = argEntry.value;
    if (value == null || _isCoreType(value)) {
      return null;
    }
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.all(8),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: SelectableText(
        value.toString(),
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Courier',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildSubtitleArgValue(
      BuildContext context, MapEntry<String, dynamic> argEntry) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isNull = argEntry.value == null;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        isNull
            ? "null"
            : _isCoreType(argEntry.value)
                ? argEntry.value.toString()
                : "Instance of '${getClassName(argEntry.value)}'",
        style: TextStyle(
          color: isNull
              ? colorScheme.error.withValues(alpha: 0.7)
              : colorScheme.secondary,
          fontSize: 12,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  Widget _buildArgs(BuildContext context) {
    return SimpleAccordion(
      children: (arguments ?? {})
          .entries
          .map(
            (argEntry) => SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: _buildArgNameAndType(context, argEntry),
              headerSubtitle: _buildSubtitleArgValue(context, argEntry),
              content: _buildContentArgValue(context, argEntry),
            ),
          )
          .toList(),
    );
  }

  String _getArgValueType(dynamic argValue) {
    if (argValue == null) {
      return "";
    }
    if (_isObjectType(argValue)) {
      return getClassName(argValue);
    }
    if (_isCoreType(argValue)) {
      return argValue.runtimeType.toString();
    }
    return argValue.runtimeType.toString();
  }

  bool _isCoreType(dynamic value) {
    if (value == null) {
      return false;
    }
    return value is bool ||
        value is int ||
        value is double ||
        value is num ||
        value is String;
  }

  bool _isObjectType(dynamic value) {
    if (value == null) {
      return false;
    }
    return !_isCoreType(value);
  }
}
