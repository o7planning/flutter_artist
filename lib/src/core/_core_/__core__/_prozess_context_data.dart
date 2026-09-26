part of '../core.dart';

abstract class ProzessContextData {}

class EmptyProzessContextData extends ProzessContextData {
  EmptyProzessContextData._();

  factory EmptyProzessContextData() => EmptyProzessContextData._();
}
