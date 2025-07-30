part of '../code.dart';

interface class IErrorListener {
  void onError() {
    throw UnimplementedError();
  }
}
