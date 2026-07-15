part of '../core.dart';

class ScalarReceivedEventInfo<ID extends Comparable> {
  final EventSourceType eventSourceType;
  final List<Type> dataTypes;

  ScalarReceivedEventInfo({
    required this.eventSourceType,
    required this.dataTypes,
  });
}
