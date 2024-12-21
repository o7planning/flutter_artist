part of '../flutter_artist.dart';

class _GlobalFluStructureGraphController {
  Function(Frame frame)? _setSelectedFrame;

  void setSelectedFrame(Frame frame) {
    if (_setSelectedFrame != null) {
      _setSelectedFrame!(frame);
    }
  }
}
