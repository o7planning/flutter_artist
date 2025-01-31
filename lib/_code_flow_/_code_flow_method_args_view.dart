part of '../flutter_artist.dart';

class _CodeFlowMethodArgsView extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const _CodeFlowMethodArgsView({
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Arguments:",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        if (arguments == null || arguments!.isEmpty) _buildEmptyArgs(),
        if (arguments != null && arguments!.isNotEmpty) _buildArgs(),
      ],
    );
  }

  Widget _buildEmptyArgs() {
    return const Text(
      " - No Arguments",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
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

  Widget _buildArgNameAndType(MapEntry<String, dynamic> argEntry) {
    return Row(
      children: [
        Text(
          argEntry.key,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            _getArgValueType(argEntry.value),
            textAlign: TextAlign.end,
            style: TextStyle(
              color: argEntry.value == null
                  ? Colors.blue
                  : _isCoreType(argEntry.value)
                      ? Colors.indigo
                      : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildContentArgValue(MapEntry<String, dynamic> argEntry) {
    dynamic value = argEntry.value;
    if (value == null || _isCoreType(value)) {
      return null;
    }
    String valueAsString = value.toString();
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      width: double.maxFinite,
      color: Colors.white,
      child: Text(
        valueAsString,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildSubtitleArgValue(MapEntry<String, dynamic> argEntry) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        argEntry.value == null
            ? "null"
            : _isCoreType(argEntry.value)
                ? argEntry.value.toString()
                : "Instance of '${getClassName(argEntry.value)}'",
        style: TextStyle(
          color: argEntry.value == null
              ? Colors.blue
              : _isCoreType(argEntry.value)
                  ? Colors.indigo
                  : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildArgs() {
    return _SimpleAccordion(
      children: (arguments ?? {})
          .entries
          .map(
            (argEntry) => _SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: _buildArgNameAndType(argEntry),
              headerSubtitle: _buildSubtitleArgValue(argEntry),
              content: _buildContentArgValue(argEntry),
            ),
          )
          .toList(),
    );
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
