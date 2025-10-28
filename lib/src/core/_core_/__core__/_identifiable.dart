part of '../core.dart';

interface class Identifiable<ID extends Object> {
  ID get id => throw UnimplementedError();
}
