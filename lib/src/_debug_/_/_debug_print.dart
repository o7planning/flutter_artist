part of '../../../flutter_artist.dart';

_DebugMsgType? _debugMsgType = _DebugMsgType.state;

enum _DebugMsgType {
  state;
}

void _debugPrint(_DebugMsgType type, String message) {
  if (type != _debugMsgType) {
    return;
  }
  print(message);
}

void _printDebugState(String message) {
  _debugPrint(_DebugMsgType.state, message);
}
