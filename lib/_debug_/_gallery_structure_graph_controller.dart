part of '../flutter_artist.dart';

class _GalleryStructureGraphController {
  Function(Frame frame)? _setSelectedFrame;

  void setSelectedFrame(Frame frame) {
    if (_setSelectedFrame != null) {
      _setSelectedFrame!(frame);
    }
  }
}
