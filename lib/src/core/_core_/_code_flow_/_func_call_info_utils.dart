part of '../core.dart';

class _FuncCallInfoUtils {

  static FuncCallInfo _buildInfo(Frame? selected,
      Map<String, dynamic>? arguments,) {
    return FuncCallInfo._(
      funcName: _cleanFunctionName(selected?.member),
      callerFuncName: null,
      filePath: selected?.uri.toString() ?? "_",
      lineNumber: selected?.line ?? -1,
      columnNumber: selected?.column ?? -1,
      arguments: arguments,
    );
  }

  static String _makeKey(Frame? f) {
    if (f == null) return "_";

    return "${f.uri}:${f.line}:${f.member}";
  }

  static Frame? _pickBestFrame(List<Frame> frames) {
    Frame? f1;
    Frame? f2;

    for (final f in frames) {
      if (!_isUserFrame(f)) continue;

      if (f1 == null) {
        f1 = f;
      } else if (f2 == null) {
        f2 = f;
        break;
      }
    }

    bool isNamed(Frame? f) =>
        f != null &&
            f.member != null &&
            f.member != '<fn>' &&
            f.member != 'closure';

    if (isNamed(f1)) return f1;
    if (isNamed(f2)) return f2;

    return f1;
  }

  static bool _isUserFrame(Frame f) {
    final uri = f.uri.toString();

    return !uri.startsWith('dart:') &&
        !uri.contains('dart-sdk') &&
        !uri.contains('flutter/') &&
        !uri.contains('internal') &&
        !uri.contains('<asynchronous suspension>');
  }

  static String _cleanFunctionName(String? raw) {
    if (raw == null || raw.isEmpty) return "-";
    String name = raw.trim();
    // remove [ ... ]
    if (name.startsWith('[') && name.endsWith(']')) {
      name = name.substring(1, name.length - 1);
    }
    // remove trailing ()
    if (name.endsWith('()')) {
      name = name.substring(0, name.length - 2);
    }
    // normalize closure / fn
    if (name == '<fn>' || name == 'closure') {
      return "-";
    }
    return name;
  }
}
