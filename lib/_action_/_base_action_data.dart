part of '../flutter_artist.dart';

abstract class BaseActionData {
  final bool needToConfirm;
  final String? actionInfo;

  const BaseActionData({
    required this.needToConfirm,
    required this.actionInfo,
  });
}
