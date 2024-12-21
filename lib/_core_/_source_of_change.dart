part of '../flutter_artist.dart';

class SourceOfChange extends Equatable {
  Type frameType;
  Type blockType;

  SourceOfChange({
    required this.frameType,
    required this.blockType,
  });

  @override
  List<Object?> get props => [frameType, blockType];

  @override
  String toString() {
    return "SourceOfChange[$frameType >> $blockType]";
  }
}

class FrameBlockType extends Equatable {
  Type frameType;
  Type blockType;

  FrameBlockType({
    required this.frameType,
    required this.blockType,
  });

  @override
  List<Object?> get props => [frameType, blockType];

  @override
  String toString() {
    return "FluBlockType[$frameType >> $blockType]";
  }
}
