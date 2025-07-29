part of '../../_fa_core.dart';

//
// _DebugMsgType? _debugMsgType = _DebugMsgType.state;
//
// enum _DebugMsgType {
//   state;
// }
//

void _debugPrint(String message) {
  print(message);
}

void _printDebugState(DebugCat debugCat, String message) {
  if (FlutterArtist.isAllowDebugCat(debugCat)) {
    _debugPrint(message);
  }
}
