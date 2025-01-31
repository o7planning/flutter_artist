part of '../flutter_artist.dart';

abstract class BaseAction {
  final bool needToConfirm;
  final String? actionInfo;

  const BaseAction({
    required this.needToConfirm,
    required this.actionInfo,
  });
}
