part of '../../core.dart';

abstract class FlowContextData {}

class EmptyFlowContextData extends FlowContextData {
  EmptyFlowContextData._();

  factory EmptyFlowContextData() => EmptyFlowContextData._();
}
