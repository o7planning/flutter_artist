part of '../flutter_artist.dart';

class _FrameRelationshipController {
  Function(FrameBlockType frameBlockType)? _setFrameBlockType;

  void setFluBlockType(FrameBlockType frameBlockType) {
    if (_setFrameBlockType != null) {
      _setFrameBlockType!(frameBlockType);
    }
  }
}
