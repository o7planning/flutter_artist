part of '../core.dart';

interface class IErrorListener {
  void onError() {
    throw UnimplementedError();
  }
}
